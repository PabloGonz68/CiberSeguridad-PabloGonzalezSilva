// ══════════════════════════════════════════════════════════════════
//  lib/core/utils/secure_logger.dart
//
//  SEGURIDAD (MASVS-STORAGE-2 / M6 — Inadequate Privacy Controls):
//  ─ NUNCA loguear: tokens, contraseñas, datos bancarios, PII.
//  ─ En modo release los logs de DEBUG e INFO están deshabilitados.
//  ─ Usa enmascaramiento de datos sensibles antes de loguear.
// ══════════════════════════════════════════════════════════════════

import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class SecureLogger {
  SecureLogger._();

  static final Logger _logger = Logger(
    // En release mode: solo WARNING y superiores
    level: kReleaseMode ? Level.warning : Level.debug,
    printer: PrettyPrinter(
      methodCount: 2,
      errorMethodCount: 8,
      lineLength: 100,
      colors: !kReleaseMode,
      printEmojis: !kReleaseMode,
      dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
    ),
    // En release: filtrar logs con datos de usuario
    output: kReleaseMode ? null : ConsoleOutput(),
  );

  // ── Patrones de datos sensibles que NUNCA deben aparecer en logs ──
  static final _sensitivePatterns = [
    RegExp(r'"password"\s*:\s*"[^"]*"', caseSensitive: false),
    RegExp(r'"token"\s*:\s*"[^"]*"', caseSensitive: false),
    RegExp(r'"access_token"\s*:\s*"[^"]*"', caseSensitive: false),
    RegExp(r'"refresh_token"\s*:\s*"[^"]*"', caseSensitive: false),
    RegExp(r'"authorization"\s*:\s*"[^"]*"', caseSensitive: false),
    RegExp(r'Bearer\s+\S+', caseSensitive: false),
    RegExp(r'\b\d{4}[\s-]?\d{4}[\s-]?\d{4}[\s-]?\d{4}\b'), // Tarjetas
    RegExp(r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}\b'), // Emails
  ];

  /// Enmascara datos sensibles de un string antes de loguearlo
  static String _sanitize(String message) {
    var sanitized = message;
    for (final pattern in _sensitivePatterns) {
      sanitized = sanitized.replaceAll(pattern, '[REDACTED]');
    }
    return sanitized;
  }

  static void debug(String message, [dynamic error]) {
    if (!kReleaseMode) {
      _logger.d(_sanitize(message), error: error);
    }
  }

  static void info(String message) {
    if (!kReleaseMode) {
      _logger.i(_sanitize(message));
    }
  }

  static void warning(String message, [dynamic error]) {
    _logger.w(_sanitize(message), error: error);
  }

  /// Solo para errores críticos — siempre sanitizados
  static void error(String message, dynamic error, [StackTrace? stackTrace]) {
    _logger.e(_sanitize(message), error: error, stackTrace: stackTrace);
  }

  /// Para amenazas de seguridad detectadas (RASP, pinning, etc.)
  static void securityAlert(String message) {
    _logger.f('🚨 SECURITY ALERT: ${_sanitize(message)}');
  }
}
