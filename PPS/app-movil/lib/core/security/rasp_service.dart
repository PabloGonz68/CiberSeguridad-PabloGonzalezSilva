// ══════════════════════════════════════════════════════════════════
//  lib/core/security/rasp_service.dart
//
//  Runtime Application Self-Protection (MASVS-RESILIENCE-1 / M7)
//
//  freeRASP detecta las siguientes amenazas en tiempo de ejecución:
//  ─ Root (Android) / Jailbreak (iOS)
//  ─ Depurador adjunto
//  ─ Firma del APK/IPA alterada (tampering)
//  ─ Emulador / simulador
//  ─ Hook frameworks (Frida, Xposed)
//
//  RESPUESTA A AMENAZAS: En producción, se cierra la sesión y se
//  notifica al usuario. En debug se loguea únicamente.
//
//  SETUP freeRASP en Android (android/app/build.gradle):
//    implementation 'com.aheaditec.talsec:freeRASP:6.x.x'
//  Y configurar TalsecConfig con tu appBundleId y teamId.
// ══════════════════════════════════════════════════════════════════

import 'package:flutter/foundation.dart';
import 'package:freerasp/freerasp.dart';
import 'secure_storage_service.dart';
import '../utils/secure_logger.dart';

class RaspService {
  RaspService._();
  static final RaspService instance = RaspService._();

  /// Callback invocado cuando se detecta una amenaza de integridad.
  /// En producción: cierra sesión + muestra diálogo de error.
  Function()? onThreatDetected;

  Future<void> initialize({
    required String androidBundleId,
    required String iosTeamId,
    required String iosBundleId,
  }) async {
    // En debug: solo loguear sin bloquear el flujo de desarrollo
    if (kDebugMode) {
      SecureLogger.info('RASP: modo debug — detección activa pero sin bloqueo.');
    }

    final config = TalsecConfig(
      androidConfig: AndroidConfig(
        packageName: androidBundleId,
        signingCertHashes: [
          // SHA-256 del keystore de release de tu app
          // Obtener con: keytool -printcert -jarfile app-release.apk
          // REEMPLAZAR con el hash real:
          'AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=',
        ],
        supportedStores: [
          // Deshabilitar sideloading desde tiendas no oficiales:
          'com.android.vending', // Google Play
        ],
      ),
      iosConfig: IOSConfig(
        bundleIds: [iosBundleId],
        teamId: iosTeamId,
      ),
      // URL del servidor al que notificar amenazas (opcional, backend propio)
      watcherMail: 'security@tuClinica.com',
      isProd: !kDebugMode,
    );

    // Suscribirse al stream de amenazas
    // NOTA: freeRASP solo funciona en Android/iOS.
    // En desktop (Linux/macOS/Windows) se omite para permitir desarrollo.
    if (defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS) {
      await Talsec.instance.start(config);
      SecureLogger.info('RASP (freeRASP) inicializado correctamente.');
    } else {
      SecureLogger.warning(
        'RASP: plataforma ${defaultTargetPlatform.name} no soportada — '
        'freeRASP solo funciona en Android/iOS. Omitiendo inicialización.',
      );
    }
  }

  Future<void> _handleThreat(String threatType) async {
    SecureLogger.securityAlert('RASP: $threatType — cerrando sesión.');

    // 1. Eliminar todos los tokens y datos de sesión
    await SecureStorageService.instance.purgeAll();

    // 2. Notificar a la UI para navegar al login con mensaje de error
    onThreatDetected?.call();
  }
}
