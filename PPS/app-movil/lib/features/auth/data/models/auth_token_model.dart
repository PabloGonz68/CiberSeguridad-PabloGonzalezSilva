// lib/features/auth/data/models/auth_token_model.dart
import '../../domain/entities/auth_token.dart';

class AuthTokenModel extends AuthToken {
  const AuthTokenModel({
    required super.accessToken,
    required super.refreshToken,
    required super.userId,
    required super.email,
    required super.expiresAt,
  });

  factory AuthTokenModel.fromJson(Map<String, dynamic> json) {
    return AuthTokenModel(
      accessToken: json['access_token'] as String,
      refreshToken: json['refresh_token'] as String,
      userId: (json['user_id'] ?? json['id']).toString(),
      email: json['email'] as String? ?? '',
      // Si el backend devuelve 'expires_in' en segundos:
      expiresAt: json.containsKey('expires_at')
          ? DateTime.parse(json['expires_at'] as String)
          : DateTime.now().add(
              Duration(seconds: (json['expires_in'] as int? ?? 3600)),
            ),
    );
  }

  Map<String, dynamic> toJson() => {
        'access_token': accessToken,
        'refresh_token': refreshToken,
        'user_id': userId,
        'email': email,
        'expires_at': expiresAt.toIso8601String(),
      };

  AuthToken toEntity() => AuthToken(
        accessToken: accessToken,
        refreshToken: refreshToken,
        userId: userId,
        email: email,
        expiresAt: expiresAt,
      );
}
