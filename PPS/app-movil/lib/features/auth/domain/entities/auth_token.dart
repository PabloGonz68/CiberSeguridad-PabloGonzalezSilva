// lib/features/auth/domain/entities/auth_token.dart
import 'package:equatable/equatable.dart';

/// Entidad de dominio pura — sin dependencias de Flutter ni JSON.
/// Representa la sesión autenticada del usuario.
class AuthToken extends Equatable {
  final String accessToken;
  final String refreshToken;
  final String userId;
  final String email;
  final DateTime expiresAt;

  const AuthToken({
    required this.accessToken,
    required this.refreshToken,
    required this.userId,
    required this.email,
    required this.expiresAt,
  });

  bool get isExpired => DateTime.now().isAfter(expiresAt);

  @override
  List<Object?> get props => [accessToken, userId, expiresAt];
}
