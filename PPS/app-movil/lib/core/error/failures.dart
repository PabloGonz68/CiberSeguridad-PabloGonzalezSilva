// ══════════════════════════════════════════════════════════════════
//  lib/core/error/failures.dart
//  Definición de Failures usando Equatable para comparación de valores.
//  Patrón Either<Failure, T> en todos los UseCases (dartz).
// ══════════════════════════════════════════════════════════════════

import 'package:equatable/equatable.dart';

/// Clase base abstracta para todos los fallos de dominio
abstract class Failure extends Equatable {
  final String message;
  const Failure({required this.message});

  @override
  List<Object> get props => [message];
}

// ── Network Failures ──────────────────────────────────────────────

/// Error genérico de comunicación con el servidor
class ServerFailure extends Failure {
  final int? statusCode;
  const ServerFailure({required super.message, this.statusCode});
  @override
  List<Object> get props => [message, statusCode ?? 0];
}

/// Sin conexión a internet
class NetworkFailure extends Failure {
  const NetworkFailure({super.message = 'Sin conexión a internet.'});
}

/// Timeout de la petición
class TimeoutFailure extends Failure {
  const TimeoutFailure({super.message = 'El servidor tardó demasiado en responder.'});
}

/// Certificate Pinning falló — posible MITM
class CertificatePinningFailure extends Failure {
  const CertificatePinningFailure({
    super.message = 'No se puede establecer una conexión segura. '
        'Por favor, comprueba tu red.',
  });
}

// ── Auth Failures ─────────────────────────────────────────────────

/// Credenciales incorrectas
class AuthFailure extends Failure {
  const AuthFailure({super.message = 'Usuario o contraseña incorrectos.'});
}

/// Token expirado o inválido
class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure({super.message = 'Sesión expirada. Vuelve a iniciar sesión.'});
}

// ── Storage Failures ──────────────────────────────────────────────

/// Error al leer/escribir en SecureStorage
class StorageFailure extends Failure {
  const StorageFailure({super.message = 'Error al acceder al almacenamiento seguro.'});
}

// ── Domain Failures ───────────────────────────────────────────────

/// Recurso no encontrado (404)
class NotFoundFailure extends Failure {
  const NotFoundFailure({super.message = 'El recurso solicitado no existe.'});
}

/// Error de validación de entrada
class ValidationFailure extends Failure {
  final Map<String, String>? fieldErrors;
  const ValidationFailure({required super.message, this.fieldErrors});
  @override
  List<Object> get props => [message, fieldErrors ?? {}];
}

/// Error de integridad de la aplicación (RASP)
class IntegrityFailure extends Failure {
  const IntegrityFailure({
    super.message = 'Se detectó una amenaza de seguridad. La sesión ha sido cerrada.',
  });
}
