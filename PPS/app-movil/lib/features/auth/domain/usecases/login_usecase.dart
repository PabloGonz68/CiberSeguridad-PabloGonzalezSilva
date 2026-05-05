// lib/features/auth/domain/usecases/login_usecase.dart
//
// SEGURIDAD (MASVS-AUTH-1 / M3):
// ─ Validación de formato en cliente ANTES de enviar al servidor.
// ─ La contraseña NUNCA se loguea ni almacena localmente.
// ─ El UseCase solo devuelve el token, no la contraseña.
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../entities/auth_token.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;
  LoginUseCase(this.repository);

  Future<Either<Failure, AuthToken>> call(LoginParams params) async {
    // Validación en cliente (segunda línea de defensa — la primera es UI)
    final emailError = _validateEmail(params.email);
    if (emailError != null) {
      return Left(ValidationFailure(message: emailError));
    }
    final passwordError = _validatePassword(params.password);
    if (passwordError != null) {
      return Left(ValidationFailure(message: passwordError));
    }

    return repository.login(
      email: params.email.trim().toLowerCase(),
      password: params.password,
    );
  }

  String? _validateEmail(String email) {
    if (email.trim().isEmpty) return 'El email es obligatorio.';
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(email.trim())) return 'El formato del email no es válido.';
    return null;
  }

  String? _validatePassword(String password) {
    if (password.isEmpty) return 'La contraseña es obligatoria.';
    if (password.length < 8) return 'La contraseña debe tener al menos 8 caracteres.';
    return null;
  }
}

class LoginParams extends Equatable {
  final String email;
  final String password;
  const LoginParams({required this.email, required this.password});

  @override
  List<Object> get props => [email]; // No incluir password en props
}
