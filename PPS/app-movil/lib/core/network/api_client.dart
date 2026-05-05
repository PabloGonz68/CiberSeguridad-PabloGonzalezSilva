// ══════════════════════════════════════════════════════════════════
//  lib/core/network/api_client.dart
//
//  Cliente HTTP Dio con interceptores de seguridad:
//  ─ Inyección automática del Bearer token en cada request
//  ─ Refresh token automático (401 → refresh → retry)
//  ─ Certificate Pinning integrado (solo Android/iOS)
//  ─ Timeouts configurados (anti-DoS pasivo)
//  ─ Manejo centralizado de errores de red
// ══════════════════════════════════════════════════════════════════

import 'package:dio/dio.dart';
import '../constants/api_constants.dart';
import '../security/secure_storage_service.dart';
import '../utils/secure_logger.dart';
import 'certificate_pinning.dart';

class ApiClient {
  ApiClient._();
  static final ApiClient instance = ApiClient._();

  Dio? _dio;
  bool _initialized = false;

  void initialize() {
    if (_initialized) return;

    try {
      _dio = Dio(
        BaseOptions(
          baseUrl: ApiConstants.baseUrl,
          connectTimeout: const Duration(milliseconds: ApiConstants.connectTimeoutMs),
          receiveTimeout: const Duration(milliseconds: ApiConstants.receiveTimeoutMs),
          sendTimeout:    const Duration(milliseconds: ApiConstants.sendTimeoutMs),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'X-Client-Platform': 'mobile',  // Cabecera de identificación
          },
          // Rechazar automáticamente cualquier respuesta fuera de 200-299
          validateStatus: (status) => status != null && status < 300,
        ),
      );

      // 1. Aplicar Certificate Pinning (solo en Android/iOS)
      CertificatePinningAdapter.apply(_dio!);

      // 2. Interceptor de autenticación (Bearer token)
      _dio!.interceptors.add(_AuthInterceptor());

      // 3. Interceptor de logging seguro (sin PII)
      _dio!.interceptors.add(_SecureLogInterceptor());

      _initialized = true;
      SecureLogger.info('ApiClient inicializado correctamente.');
    } catch (e, stack) {
      SecureLogger.error('Error al inicializar ApiClient', e, stack);
      // Crear un Dio básico como fallback para que la app no crashee
      _dio = Dio(BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(milliseconds: ApiConstants.connectTimeoutMs),
        receiveTimeout: const Duration(milliseconds: ApiConstants.receiveTimeoutMs),
      ));
      _initialized = true;
    }
  }

  Dio get dio {
    if (!_initialized) initialize();
    return _dio!;
  }
}

// ── Interceptor: Inyección de Bearer Token ────────────────────────
class _AuthInterceptor extends QueuedInterceptorsWrapper {
  final _storage = SecureStorageService.instance;
  bool _isRefreshing = false;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _storage.getAccessToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode == 401 && !_isRefreshing) {
      _isRefreshing = true;
      try {
        final refreshed = await _refreshToken();
        if (refreshed) {
          // Reintentar la request original con el nuevo token
          final newToken = await _storage.getAccessToken();
          err.requestOptions.headers['Authorization'] = 'Bearer $newToken';

          final dio = ApiClient.instance.dio;
          final retryResponse = await dio.fetch(err.requestOptions);
          handler.resolve(retryResponse);
          return;
        }
      } catch (e) {
        SecureLogger.warning('Refresh token falló, cerrando sesión.', e);
        // Limpiar todo el storage y forzar logout
        await _storage.purgeAll();
      } finally {
        _isRefreshing = false;
      }
    }
    handler.next(err);
  }

  Future<bool> _refreshToken() async {
    try {
      final refreshToken = await _storage.getRefreshToken();
      if (refreshToken == null) return false;

      final response = await ApiClient.instance.dio.post(
        ApiConstants.refreshToken,
        data: {'refresh_token': refreshToken},
      );

      if (response.statusCode == 200 && response.data != null) {
        final newAccessToken = response.data['access_token'] as String?;
        final newRefreshToken = response.data['refresh_token'] as String?;

        if (newAccessToken != null) {
          await _storage.saveAccessToken(newAccessToken);
        }
        if (newRefreshToken != null) {
          await _storage.saveRefreshToken(newRefreshToken);
        }
        return true;
      }
      return false;
    } catch (e) {
      SecureLogger.error('Error en _refreshToken', e);
      return false;
    }
  }
}

// ── Interceptor: Logging Seguro ───────────────────────────────────
class _SecureLogInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Log solo método y path — NUNCA headers de Authorization ni body
    SecureLogger.debug('→ ${options.method} ${options.path}');
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    SecureLogger.debug(
      '← ${response.statusCode} ${response.requestOptions.path}',
    );
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    SecureLogger.warning(
      '✗ Error ${err.response?.statusCode} ${err.requestOptions.path}: '
      '${err.type.name}',
      err,
    );
    handler.next(err);
  }
}
