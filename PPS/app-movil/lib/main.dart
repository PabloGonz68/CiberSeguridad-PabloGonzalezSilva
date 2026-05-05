// lib/main.dart
// Entry point de la aplicación VetClinic
//
// SEGURIDAD en startup (MASVS-RESILIENCE / M7):
// 1. Inicializa freeRASP ANTES de cualquier lógica de negocio
// 2. Inicializa el ApiClient con Certificate Pinning activo
// 3. Comprueba sesión existente en SecureStorage
// 4. Ningún dato sensible se expone antes del check de sesión

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'app/config/app_router.dart';
import 'app/config/app_theme.dart';
import 'app/di/injection_container.dart' as di;
import 'app/di/injection_container.dart';
import 'core/security/rasp_service.dart';
import 'core/utils/secure_logger.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/bloc/auth_event.dart';
import 'package:go_router/go_router.dart';


void main() async {
  // Asegura que los bindings de Flutter estén inicializados
  WidgetsFlutterBinding.ensureInitialized();

  // Forzar orientación portrait (menor superficie de ataque en UI)
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Ocultar barra de sistema para UI inmersiva segura
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarBrightness: Brightness.dark,
    systemNavigationBarColor: Color(0xFF0D1117),
  ));

  // 1. Inicializar inyección de dependencias
  await di.initDependencies();
  SecureLogger.info('DI container inicializado.');

  // 2. Inicializar RASP — detectar amenazas en tiempo de arranque
  // NOTA: Reemplazar packageName/bundleId/teamId con los valores reales.
  await RaspService.instance.initialize(
    androidBundleId: 'com.vetclinica.app',
    iosTeamId: 'XXXXXXXXXX',          // 10-char Apple Team ID
    iosBundleId: 'com.vetclinica.app',
  );
  SecureLogger.info('RASP inicializado.');

  runApp(const VetClinicApp());
}

class VetClinicApp extends StatefulWidget {
  const VetClinicApp({super.key});
  @override
  State<VetClinicApp> createState() => _VetClinicAppState();
}

class _VetClinicAppState extends State<VetClinicApp> {
  late final AuthBloc _authBloc;
  late final GoRouter _router;  // ← GoRouter se importa vía app_router.dart

  @override
  void initState() {
    super.initState();
    _authBloc = sl<AuthBloc>();
    _router = createAppRouter(_authBloc);
    // Comprobar sesión existente al arrancar
    _authBloc.add(const AuthCheckSession());
  }

  @override
  void dispose() {
    _authBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _authBloc,
      child: MaterialApp.router(
        title: 'VetClinic',
        debugShowCheckedModeBanner: false,    // Sin banner en debug
        theme: AppTheme.darkTheme,
        routerConfig: _router,

        // Localización completa — necesaria para TextFields en es_ES
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        locale: const Locale('es', 'ES'),
        supportedLocales: const [
          Locale('es', 'ES'),
          Locale('en', 'US'),
        ],
      ),
    );
  }
}
