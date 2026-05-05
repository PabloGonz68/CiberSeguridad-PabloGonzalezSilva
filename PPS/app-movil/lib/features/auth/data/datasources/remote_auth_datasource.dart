// lib/features/auth/data/datasources/remote_auth_datasource.dart
//
// SEGURIDAD: El login se realiza directamente contra Supabase Auth.
// El backend Express solo valida tokens — NO tiene endpoint de login.
// El flujo es:
//   1. App → Supabase Auth (signInWithPassword) → obtiene JWT
//   2. App envía JWT al backend Express en headers Authorization
//   3. Backend valida JWT con checkAuth middleware

import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../../core/env/env.dart';
import '../../../../core/utils/secure_logger.dart';
import '../models/auth_token_model.dart';

abstract class RemoteAuthDataSource {
  Future<AuthTokenModel> login({required String email, required String password});
  Future<void> logout({required String accessToken});
}

class RemoteAuthDataSourceImpl implements RemoteAuthDataSource {
  final Dio _dio;

  // URL de Supabase Auth — se lee del .env del backend
  // En producción: esta URL se configura en el .env de la app Flutter
  static const String _supabaseUrl = 'https://afufwmurrikyxfzxzfzk.supabase.co';
  static const String _supabaseAnonKey = 'sb_publishable_gLq6sUJXTiWnfuubdBr_Wg_pp1LJEyj';

  RemoteAuthDataSourceImpl() : _dio = Dio();

  @override
  Future<AuthTokenModel> login({
    required String email,
    required String password,
  }) async {
    // Login directo contra Supabase Auth REST API
    // Endpoint: POST /auth/v1/token?grant_type=password
    // Docs: https://supabase.com/docs/reference/dart/auth-signinwithpassword
    final response = await _dio.post(
      '$_supabaseUrl/auth/v1/token?grant_type=password',
      data: {
        'email': email,
        'password': password,
      },
      options: Options(
        headers: {
          'apikey': _supabaseAnonKey,
          'Content-Type': 'application/json',
        },
      ),
    );

    SecureLogger.info('Auth: login exitoso contra Supabase.');

    final data = response.data as Map<String, dynamic>;

    // Supabase devuelve:
    // {
    //   "access_token": "eyJ...",
    //   "token_type": "bearer",
    //   "expires_in": 3600,
    //   "refresh_token": "xxx",
    //   "user": { "id": "uuid", "email": "user@example.com", ... }
    // }
    return AuthTokenModel(
      accessToken: data['access_token'] as String,
      refreshToken: data['refresh_token'] as String? ?? '',
      userId: (data['user']?['id'] ?? '').toString(),
      email: (data['user']?['email'] ?? email).toString(),
      expiresAt: DateTime.now().add(
        Duration(seconds: data['expires_in'] as int? ?? 3600),
      ),
    );
  }

  @override
  Future<void> logout({required String accessToken}) async {
    try {
      // Invalidar sesión en Supabase
      await _dio.post(
        '$_supabaseUrl/auth/v1/logout',
        options: Options(
          headers: {
            'apikey': _supabaseAnonKey,
            'Authorization': 'Bearer $accessToken',
            'Content-Type': 'application/json',
          },
        ),
      );
      SecureLogger.info('Auth: logout completado en Supabase.');
    } catch (e) {
      // Aunque falle el servidor, el cliente siempre purga el storage
      SecureLogger.warning(
        'Auth: logout en Supabase falló — storage local purgado igualmente.', e,
      );
    }
  }
}
