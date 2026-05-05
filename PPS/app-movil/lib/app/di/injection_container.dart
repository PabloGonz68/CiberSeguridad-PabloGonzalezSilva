// lib/app/di/injection_container.dart
// Inyección de dependencias con GetIt (service locator)

import 'package:get_it/get_it.dart';
import 'package:local_auth/local_auth.dart';
import '../../core/network/api_client.dart';
import '../../core/security/secure_storage_service.dart';
import '../../core/security/rasp_service.dart';
import '../../core/utils/secure_logger.dart';
import '../../features/auth/data/datasources/remote_auth_datasource.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';

final sl = GetIt.instance; // Service Locator

Future<void> initDependencies() async {
  // ── Servicios de infraestructura ────────────────────────────
  sl.registerLazySingleton<SecureStorageService>(
    () => SecureStorageService.instance,
  );
  sl.registerLazySingleton<RaspService>(
    () => RaspService.instance,
  );

  // Inicializar ApiClient antes de registrarlo
  ApiClient.instance.initialize();
  sl.registerLazySingleton<ApiClient>(
    () => ApiClient.instance,
  );

  sl.registerLazySingleton<LocalAuthentication>(
    () => LocalAuthentication(),
  );

  // ── Feature: Auth ────────────────────────────────────────────
  // Data sources
  sl.registerLazySingleton<RemoteAuthDataSource>(() {
    try {
      return RemoteAuthDataSourceImpl();
    } catch (e, stack) {
      SecureLogger.error('Error while creating RemoteAuthDataSource', e, stack);
      rethrow;
    }
  });

  // Repositories
  sl.registerLazySingleton<AuthRepository>(() {
    try {
      return AuthRepositoryImpl(
        remoteDataSource: sl<RemoteAuthDataSource>(),
        storage: sl<SecureStorageService>(),
      );
    } catch (e, stack) {
      SecureLogger.error('Error while creating AuthRepository', e, stack);
      rethrow;
    }
  });

  // Use cases
  sl.registerLazySingleton(() {
    try {
      return LoginUseCase(sl<AuthRepository>());
    } catch (e, stack) {
      SecureLogger.error('Error while creating LoginUseCase', e, stack);
      rethrow;
    }
  });

  // BLoC — factory para que cada árbol de widgets obtenga una instancia
  sl.registerFactory(() {
    try {
      return AuthBloc(
        loginUseCase: sl<LoginUseCase>(),
        authRepository: sl<AuthRepository>(),
        localAuth: sl<LocalAuthentication>(),
      );
    } catch (e, stack) {
      SecureLogger.error('Error while creating AuthBloc', e, stack);
      rethrow;
    }
  });
}
