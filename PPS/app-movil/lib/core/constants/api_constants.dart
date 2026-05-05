// ══════════════════════════════════════════════════════════════════
//  lib/core/constants/api_constants.dart
//
//  Endpoints mapeados al backend existente (clinica-segura-backend)
//  que corre en Express + Supabase en el puerto 3000.
//
//  SEGURIDAD: NUNCA hardcodear la URL base aquí — se lee desde
//  Env.apiBaseUrl que es generado por 'envied' con obfuscate:true.
// ══════════════════════════════════════════════════════════════════

import '../env/env.dart';

class ApiConstants {
  ApiConstants._(); // Clase no instanciable

  // ── Base ──────────────────────────────────────────────────────
  // Valor leído desde .env → cifrado en compilación por envied
  static String get baseUrl => Env.apiBaseUrl;

  // ── Health check ──────────────────────────────────────────────
  static String get health => '$baseUrl/health';

  // ── Auth (Supabase via backend) ───────────────────────────────
  // El backend usa Supabase Auth — los tokens son JWT de Supabase
  static String get login => '$baseUrl/auth/login';
  static String get logout => '$baseUrl/auth/logout';
  static String get refreshToken => '$baseUrl/auth/refresh';

  // ── Perfil del usuario ────────────────────────────────────────
  // GET /api/perfil — protegido con checkAuth
  static String get profile => '$baseUrl/perfil';

  // ── Tienda / Store ─────────────────────────────────────────────
  // GET /api/tienda/productos
  // GET /api/tienda/ofertas-exclusivas (requiere haber adoptado — ABAC)
  static String get products => '$baseUrl/tienda/productos';
  static String get exclusiveOffers => '$baseUrl/tienda/ofertas-exclusivas';
  static String productDetail(String id) => '$baseUrl/tienda/productos/$id';

  // ── Adopciones ────────────────────────────────────────────────
  static String get adoptions => '$baseUrl/adopciones';
  static String adoptionDetail(String id) => '$baseUrl/adopciones/$id';
  static String get adoptionRequest => '$baseUrl/adopciones/solicitud';

  // ── Mascotas del usuario ──────────────────────────────────────
  static String get pets => '$baseUrl/mascotas';
  static String petDetail(String id) => '$baseUrl/mascotas/$id';

  // ── Timeouts (ms) ─────────────────────────────────────────────
  static const int connectTimeoutMs = 10000;
  static const int receiveTimeoutMs = 15000;
  static const int sendTimeoutMs = 10000;
}
