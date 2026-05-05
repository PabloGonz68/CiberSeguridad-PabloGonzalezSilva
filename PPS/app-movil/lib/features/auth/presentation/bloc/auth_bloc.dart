// lib/features/auth/presentation/bloc/auth_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_auth/local_auth.dart';
import '../../../../core/security/rasp_service.dart';
import '../../../../core/utils/secure_logger.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/entities/auth_token.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase _loginUseCase;
  final AuthRepository _authRepository;
  final LocalAuthentication _localAuth;

  AuthBloc({
    required LoginUseCase loginUseCase,
    required AuthRepository authRepository,
    LocalAuthentication? localAuth,
  })  : _loginUseCase = loginUseCase,
        _authRepository = authRepository,
        _localAuth = localAuth ?? LocalAuthentication(),
        super(const AuthInitial()) {
    on<AuthCheckSession>(_onCheckSession);
    on<AuthLoginRequested>(_onLoginRequested);
    on<AuthLogoutRequested>(_onLogoutRequested);
    on<AuthBiometricRequested>(_onBiometricRequested);

    // Conectar RASP: si se detecta amenaza, emitir logout automático
    RaspService.instance.onThreatDetected = () {
      add(const AuthLogoutRequested());
      emit(const AuthError(
        message: 'Se detectó una amenaza de seguridad. Por favor, '
            'contacta con soporte si el problema persiste.',
        isCriticalSecurity: true,
      ));
    };
  }

  Future<void> _onCheckSession(
    AuthCheckSession event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    final hasSession = await _authRepository.hasValidSession();
    if (hasSession) {
      // Sesión válida en SecureStorage — emitir estado autenticado
      // (el token real se recargará desde storage cuando sea necesario)
      SecureLogger.info('AuthBloc: sesión válida encontrada.');
      emit(const AuthUnauthenticated()); // Redirigir al check de biométrica
    } else {
      emit(const AuthUnauthenticated());
    }
  }

  Future<void> _onLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    final result = await _loginUseCase(
      LoginParams(email: event.email, password: event.password),
    );
    result.fold(
      (failure) {
        SecureLogger.warning('AuthBloc: login fallido — ${failure.message}');
        emit(AuthError(message: failure.message));
      },
      (token) {
        SecureLogger.info('AuthBloc: login exitoso.');
        emit(AuthAuthenticated(token: token));
      },
    );
  }

  Future<void> _onLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    await _authRepository.logout();
    SecureLogger.info('AuthBloc: logout completado.');
    emit(const AuthUnauthenticated());
  }

  Future<void> _onBiometricRequested(
    AuthBiometricRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      final canUseBiometrics = await _localAuth.canCheckBiometrics;
      final isSupported = await _localAuth.isDeviceSupported();

      if (!canUseBiometrics || !isSupported) {
        emit(const AuthError(message: 'Biometría no disponible en este dispositivo.'));
        return;
      }

      final authenticated = await _localAuth.authenticate(
        localizedReason: 'Usa tu huella o Face ID para acceder a VetClinic',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );

      if (authenticated) {
        // La biométrica verifica la identidad local — el token ya está en storage
        final hasSession = await _authRepository.hasValidSession();
        if (hasSession) {
          SecureLogger.info('AuthBloc: autenticación biométrica exitosa.');
          // Emitir estado autenticado (token se recupera de storage)
          emit(AuthAuthenticated(
            token: AuthToken(
              accessToken: '',  // Se leerá de SecureStorage en el próximo request
              refreshToken: '',
              userId: '',
              email: '',
              expiresAt: DateTime.now().add(const Duration(hours: 1)),
            ),
          ));
        } else {
          emit(const AuthUnauthenticated());
        }
      }
    } catch (e, stack) {
      SecureLogger.error('AuthBloc: error en biometría', e, stack);
      emit(const AuthError(message: 'Error al verificar biometría.'));
    }
  }
}
