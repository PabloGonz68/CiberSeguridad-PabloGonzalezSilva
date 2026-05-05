// lib/app/widgets/main_shell.dart
// Shell de navegación principal con BottomNavigationBar

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../config/app_theme.dart';
import '../config/app_router.dart';

class MainShell extends StatelessWidget {
  final Widget child;
  const MainShell({super.key, required this.child});

  int _currentIndex(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    if (location.startsWith('/home/store')) return 0;
    if (location.startsWith('/home/adoptions')) return 1;
    if (location.startsWith('/home/profile')) return 2;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = _currentIndex(context);
    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      body: child,
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: AppTheme.surfaceColor,
          border: Border(top: BorderSide(color: AppTheme.borderColor, width: 1)),
        ),
        child: NavigationBar(
          backgroundColor: AppTheme.surfaceColor,
          selectedIndex: currentIndex,
          indicatorColor: AppTheme.primaryColor.withOpacity(0.15),
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          onDestinationSelected: (index) {
            switch (index) {
              case 0: context.go(AppRoutes.store);
              case 1: context.go(AppRoutes.adoptions);
              case 2: context.go(AppRoutes.profile);
            }
          },
          destinations: [
            NavigationDestination(
              icon: const Icon(Icons.storefront_outlined, color: AppTheme.textSecondary),
              selectedIcon: const Icon(Icons.storefront, color: AppTheme.primaryColor),
              label: 'Tienda',
            ),
            NavigationDestination(
              icon: const Icon(Icons.favorite_border, color: AppTheme.textSecondary),
              selectedIcon: const Icon(Icons.favorite, color: AppTheme.primaryColor),
              label: 'Adopciones',
            ),
            NavigationDestination(
              icon: const Icon(Icons.person_outline, color: AppTheme.textSecondary),
              selectedIcon: const Icon(Icons.person, color: AppTheme.primaryColor),
              label: 'Perfil',
            ),
          ],
        ),
      ),
    );
  }
}
