// lib/app/config/app_router.dart
// Routing con GoRouter + auth guard (MASVS-AUTH: protección de rutas)

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/bloc/auth_state.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/store/presentation/pages/store_page.dart';
import '../../features/store/presentation/pages/product_detail_page.dart';
import '../../features/adoptions/presentation/pages/adoptions_page.dart';
import '../../features/adoptions/presentation/pages/animal_detail_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/profile/presentation/pages/pets_page.dart';
import '../widgets/main_shell.dart';

// ── Nombres de rutas (constantes) ─────────────────────────────────
class AppRoutes {
  static const login        = '/login';
  static const home         = '/home';
  static const store        = '/home/store';
  static const productDetail= '/home/store/:id';
  static const adoptions    = '/home/adoptions';
  static const animalDetail = '/home/adoptions/:id';
  static const profile      = '/home/profile';
  static const pets         = '/home/profile/pets';
}

GoRouter createAppRouter(AuthBloc authBloc) {
  return GoRouter(
    initialLocation: AppRoutes.login,
    debugLogDiagnostics: false, // Desactivar en producción

    // ── Auth Guard Global ──────────────────────────────────────
    // SEGURIDAD: Redirige al login si no hay sesión válida.
    // Ninguna ruta protegida es accesible sin autenticación.
    redirect: (context, state) {
      final authState = authBloc.state;
      final isLoggingIn = state.matchedLocation == AppRoutes.login;

      if (authState is AuthUnauthenticated || authState is AuthInitial) {
        return isLoggingIn ? null : AppRoutes.login;
      }
      if (authState is AuthAuthenticated) {
        return isLoggingIn ? AppRoutes.store : null;
      }
      return null;
    },

    // Refrescar router cuando cambia el estado de auth
    refreshListenable: GoRouterAuthNotifier(authBloc),

    routes: [
      // ── Pública: Login ─────────────────────────────────────
      GoRoute(
        path: AppRoutes.login,
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: AppRoutes.home,
        redirect: (context, state) => AppRoutes.store,
      ),

      // ── Shell con BottomNavigationBar (rutas protegidas) ───
      ShellRoute(
        builder: (context, state, child) => MainShell(child: child),
        routes: [
          // Tienda
          GoRoute(
            path: AppRoutes.store,
            name: 'store',
            builder: (context, state) => const StorePage(),
            routes: [
              GoRoute(
                path: ':id',
                name: 'productDetail',
                builder: (context, state) => ProductDetailPage(
                  productId: state.pathParameters['id']!,
                ),
              ),
            ],
          ),
          // Adopciones
          GoRoute(
            path: AppRoutes.adoptions,
            name: 'adoptions',
            builder: (context, state) => const AdoptionsPage(),
            routes: [
              GoRoute(
                path: ':id',
                name: 'animalDetail',
                builder: (context, state) => AnimalDetailPage(
                  animalId: state.pathParameters['id']!,
                ),
              ),
            ],
          ),
          // Perfil y Mascotas
          GoRoute(
            path: AppRoutes.profile,
            name: 'profile',
            builder: (context, state) => const ProfilePage(),
            routes: [
              GoRoute(
                path: 'pets',
                name: 'pets',
                builder: (context, state) => const PetsPage(),
              ),
            ],
          ),
        ],
      ),
    ],

    // Pantalla de error personalizada
    errorBuilder: (context, state) => Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 48),
            const SizedBox(height: 16),
            Text(
              'Ruta no encontrada',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ],
        ),
      ),
    ),
  );
}

/// Notificador que informa a GoRouter cuando el estado de auth cambia.
class GoRouterAuthNotifier extends ChangeNotifier {
  final AuthBloc _authBloc;
  GoRouterAuthNotifier(this._authBloc) {
    _authBloc.stream.listen((_) => notifyListeners());
  }
}
