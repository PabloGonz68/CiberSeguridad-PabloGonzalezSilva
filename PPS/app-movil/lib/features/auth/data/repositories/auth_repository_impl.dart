// lib/features/auth/data/repositories/auth_repository_impl.dart
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/security/secure_storage_service.dart';
import '../../../../core/utils/secure_logger.dart';
import '../../domain/entities/auth_token.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/remote_auth_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final RemoteAuthDataSource _remoteDataSource;
  final SecureStorageService _storage;

  AuthRepositoryImpl({
    required RemoteAuthDataSource remoteDataSource,
    required SecureStorageService storage,
  })  : _remoteDataSource = remoteDataSource,
        _storage = storage;

  @override
  Future<Either<Failure, AuthToken>> login({
    required String email,
    required String password,
  }) async {
    try {
      final tokenModel = await _remoteDataSource.login(
        email: email,
        password: password,
      );

      // Persistir tokens en SecureStorage (Keystore / Keychain)
      await _storage.saveAccessToken(tokenModel.accessToken);
      await _storage.saveRefreshToken(tokenModel.refreshToken);
      await _storage.saveUserId(tokenModel.userId);

      return Right(tokenModel.toEntity());
    } on DioException catch (e) {
      return Left(_mapDioErrorToFailure(e));
    } catch (e, stack) {
      SecureLogger.error('Login: error inesperado', e, stack);
      return Left(ServerFailure(message: 'Error inesperado. Inténtalo de nuevo.'));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      final token = await _storage.getAccessToken();
      if (token != null) {
        await _remoteDataSource.logout(accessToken: token);
      }
      // Siempre purgar el storage local, independientemente del servidor
      await _storage.purgeAll();
      return const Right(null);
    } catch (e, stack) {
      SecureLogger.error('Logout: error', e, stack);
      // Aún así purgar storage — seguridad primero
      await _storage.purgeAll();
      return const Right(null);
    }
  }

  @override
  Future<bool> hasValidSession() async {
    final token = await _storage.getAccessToken();
    return token != null && token.isNotEmpty;
  }

  Failure _mapDioErrorToFailure(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return const TimeoutFailure();
      case DioExceptionType.connectionError:
        return const NetworkFailure();
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        if (statusCode == 401 || statusCode == 403) {
          return const AuthFailure();
        }
        if (statusCode == 404) return const NotFoundFailure();
        return ServerFailure(
          message: 'Error del servidor ($statusCode).',
          statusCode: statusCode,
        );
      case DioExceptionType.badCertificate:
        return const CertificatePinningFailure();
      default:
        return const ServerFailure(message: 'Error de red desconocido.');
    }
  }
}
