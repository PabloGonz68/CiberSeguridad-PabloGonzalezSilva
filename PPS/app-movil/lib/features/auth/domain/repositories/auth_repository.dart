// lib/features/auth/domain/repositories/auth_repository.dart
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/auth_token.dart';

/// Contrato de repositorio — implementado en la capa Data.
/// La capa Domain no conoce Dio, SharedPreferences, ni ningún framework.
abstract class AuthRepository {
  /// Autentica al usuario con email y contraseña.
  /// Devuelve [AuthToken] o un [Failure] descriptivo.
  Future<Either<Failure, AuthToken>> login({
    required String email,
    required String password,
  });

  /// Cierra sesión: invalida el token en el servidor y purga storage.
  Future<Either<Failure, void>> logout();

  /// Verifica si existe una sesión activa y válida en SecureStorage.
  Future<bool> hasValidSession();
}
