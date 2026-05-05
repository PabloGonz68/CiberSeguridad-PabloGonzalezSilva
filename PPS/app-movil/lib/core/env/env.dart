// ══════════════════════════════════════════════════════════════════
//  lib/core/env/env.dart
//
//  Variables de entorno para la app.
//
//  SEGURIDAD (MASVS-STORAGE-2 / M1 — Improper Credential Usage):
//  ─ En PRODUCCIÓN: usar envied con obfuscate:true + build_runner
//    para cifrar valores en compilación (ver env.dart.prod).
//  ─ En DESARROLLO: lectura directa desde Platform.environment o
//    valores por defecto para poder ejecutar sin code generation.
//
//  NOTA: Para builds de release, reemplazar este archivo por la
//  versión con envied y ejecutar:
//    flutter pub run build_runner build --delete-conflicting-outputs
// ══════════════════════════════════════════════════════════════════

import 'dart:io' show Platform;

class Env {
  Env._();

  /// URL base de la API backend
  /// Lee de la variable de entorno del sistema, o usa el valor por defecto
  /// para desarrollo local (emulador Android → host)
  static String get apiBaseUrl =>
      Platform.environment['API_BASE_URL'] ??
      const String.fromEnvironment(
        'API_BASE_URL',
        defaultValue: 'http://localhost:3000/api',
      );

  /// SHA-256 fingerprint primario del certificado TLS
  static String get certPinSha256 =>
      Platform.environment['CERT_PIN_SHA256'] ??
      const String.fromEnvironment(
        'CERT_PIN_SHA256',
        defaultValue: 'sha256/AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=',
      );

  /// SHA-256 fingerprint de backup (para rotación de certificados)
  static String get certPinBackupSha256 =>
      Platform.environment['CERT_PIN_BACKUP_SHA256'] ??
      const String.fromEnvironment(
        'CERT_PIN_BACKUP_SHA256',
        defaultValue: 'sha256/BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB=',
      );
}
