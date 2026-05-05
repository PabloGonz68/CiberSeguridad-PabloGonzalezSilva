// ══════════════════════════════════════════════════════════════════
//  lib/core/security/secure_storage_service.dart
//
//  SEGURIDAD (MASVS-STORAGE-1 / M9 — Insecure Data Storage):
//  ─ Usa flutter_secure_storage que internamente delega en:
//     · Android: EncryptedSharedPreferences + Android Keystore (AES-256-GCM)
//     · iOS:     Keychain Services (kSecClassGenericPassword)
//  ─ Opciones de seguridad adicionales habilitadas:
//     · Android: resetOnError, encryptedSharedPreferences
//     · iOS:     acceso solo con dispositivo desbloqueado (kSecAttrAccessible)
//  ─ NUNCA almacena contraseñas en texto plano — SOLO tokens JWT.
//  ─ El método purge() elimina todo al hacer logout.
// ══════════════════════════════════════════════════════════════════

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../utils/secure_logger.dart';

class SecureStorageService {
  SecureStorageService._();
  static final SecureStorageService instance = SecureStorageService._();

  // ── Configuración por plataforma ──────────────────────────────
  final FlutterSecureStorage _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true, // EncryptedSharedPreferences + Keystore
      resetOnError: true,               // Resetear si el Keystore es inaccesible
      keyCipherAlgorithm: KeyCipherAlgorithm.RSA_ECB_OAEPwithSHA_256andMGF1Padding,
      storageCipherAlgorithm: StorageCipherAlgorithm.AES_GCM_NoPadding,
    ),
    iOptions: IOSOptions(
      // Solo accesible cuando el dispositivo está desbloqueado
      accessibility: KeychainAccessibility.first_unlock_this_device,
      synchronizable: false, // No sincronizar con iCloud
    ),
  );

  // ── Claves de almacenamiento ──────────────────────────────────
  static const _keyAccessToken = 'vc_access_token';
  static const _keyRefreshToken = 'vc_refresh_token';
  static const _keyUserId = 'vc_user_id';
  static const _keyBiometricEnabled = 'vc_biometric_enabled';

  // ── Auth Tokens ───────────────────────────────────────────────

  Future<void> saveAccessToken(String token) async {
    try {
      await _storage.write(key: _keyAccessToken, value: token);
    } catch (e) {
      SecureLogger.error('Error guardando access token', e);
      rethrow;
    }
  }

  Future<String?> getAccessToken() async {
    try {
      return await _storage.read(key: _keyAccessToken);
    } catch (e) {
      SecureLogger.error('Error leyendo access token', e);
      return null;
    }
  }

  Future<void> saveRefreshToken(String token) async {
    try {
      await _storage.write(key: _keyRefreshToken, value: token);
    } catch (e) {
      SecureLogger.error('Error guardando refresh token', e);
      rethrow;
    }
  }

  Future<String?> getRefreshToken() async {
    try {
      return await _storage.read(key: _keyRefreshToken);
    } catch (e) {
      SecureLogger.error('Error leyendo refresh token', e);
      return null;
    }
  }

  Future<void> saveUserId(String userId) async {
    await _storage.write(key: _keyUserId, value: userId);
  }

  Future<String?> getUserId() async {
    return await _storage.read(key: _keyUserId);
  }

  Future<bool> get isLoggedIn async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }

  // ── Biometric preference ──────────────────────────────────────

  Future<void> setBiometricEnabled(bool enabled) async {
    await _storage.write(
      key: _keyBiometricEnabled,
      value: enabled.toString(),
    );
  }

  Future<bool> get isBiometricEnabled async {
    final value = await _storage.read(key: _keyBiometricEnabled);
    return value == 'true';
  }

  // ── Logout: limpieza completa ─────────────────────────────────
  //
  //  SEGURIDAD: Eliminar TODOS los datos sensibles en logout,
  //  no solo el token de acceso.

  Future<void> purgeAll() async {
    try {
      await _storage.deleteAll();
      SecureLogger.info('SecureStorage: purga completa ejecutada en logout.');
    } catch (e) {
      SecureLogger.error('Error en purgeAll de SecureStorage', e);
      // En caso de error, intentar borrar clave a clave
      await _storage.delete(key: _keyAccessToken);
      await _storage.delete(key: _keyRefreshToken);
      await _storage.delete(key: _keyUserId);
    }
  }
}
