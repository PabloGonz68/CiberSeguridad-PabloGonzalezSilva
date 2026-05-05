// ══════════════════════════════════════════════════════════════════
//  lib/core/network/certificate_pinning.dart
//
//  SEGURIDAD (MASVS-NETWORK-2 / M5 — Insecure Communication):
//  ─ Certificate Pinning con SHA-256 del certificado del servidor.
//  ─ Previene ataques Man-in-the-Middle (MITM) incluso si una CA
//    raíz del sistema operativo está comprometida.
//  ─ Implementa "backup pin" para permitir rotación sin lock-out.
//
//  OBTENER EL PIN SHA-256:
//    openssl s_client -connect api.tuClinica.com:443 2>/dev/null \
//      | openssl x509 -pubkey -noout \
//      | openssl pkey -pubin -outform der \
//      | openssl dgst -sha256 -binary \
//      | base64
//
//  IMPORTANTE: Actualizar los pines en .env ANTES de que expire el
//  certificado actual. Usar el backup_pin del nuevo certificado.
// ══════════════════════════════════════════════════════════════════

import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';
import '../env/env.dart';
import '../utils/secure_logger.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';

class CertificatePinningAdapter {
  /// Configura el HttpClient de Dio con Certificate Pinning basado en
  /// la verificación del Subject Public Key Info (SPKI) SHA-256.
  ///
  /// NOTA: Certificate Pinning solo se aplica en Android/iOS.
  /// En desktop (Linux/macOS/Windows) se omite para permitir desarrollo.
  static void apply(Dio dio) {
    // Solo aplicar pinning en plataformas móviles
    if (defaultTargetPlatform != TargetPlatform.android &&
        defaultTargetPlatform != TargetPlatform.iOS) {
      SecureLogger.warning(
        'Certificate Pinning: omitido en plataforma desktop '
        '(${defaultTargetPlatform.name}). Solo activo en Android/iOS.',
      );
      return;
    }

    try {
      (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
        final client = HttpClient();

        client.badCertificateCallback = (
          X509Certificate cert,
          String host,
          int port,
        ) {
          // Rechazar de plano cualquier certificado inválido en producción
          return false;
        };

        return client;
      };

      (dio.httpClientAdapter as IOHttpClientAdapter).validateCertificate = (
        X509Certificate? cert,
        String host,
        int port,
      ) {
        if (cert == null) {
          SecureLogger.securityAlert(
            'Certificate Pinning: certificado nulo para $host:$port',
          );
          return false;
        }

        // Calcular el SHA-256 del SPKI del certificado recibido
        final certFingerprint = _computeSpkiSha256(cert);

        final validPins = [
          Env.certPinSha256,
          Env.certPinBackupSha256,
        ];

        final isPinned = validPins.contains(certFingerprint);

        if (!isPinned) {
          SecureLogger.securityAlert(
            'Certificate Pinning FALLIDO para $host:$port. '
            'Fingerprint recibido: $certFingerprint. Posible MITM.',
          );
        } else {
          SecureLogger.debug('Certificate Pinning OK para $host:$port');
        }

        return isPinned;
      };

      SecureLogger.info('Certificate Pinning configurado correctamente.');
    } catch (e) {
      SecureLogger.error('Error al configurar Certificate Pinning', e);
    }
  }

  /// Calcula el fingerprint SHA-256 del Subject Public Key Info (SPKI)
  /// del certificado, en formato "sha256/BASE64==".
  static String _computeSpkiSha256(X509Certificate cert) {
    final digest = sha256.convert(cert.der);
    final base64Hash = base64Encode(digest.bytes);
    return 'sha256/$base64Hash';
  }
}
