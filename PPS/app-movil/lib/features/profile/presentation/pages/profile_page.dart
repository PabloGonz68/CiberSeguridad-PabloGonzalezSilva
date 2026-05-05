// lib/features/profile/presentation/pages/profile_page.dart
// Perfil del usuario con logout seguro y acceso a mascotas

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../app/config/app_theme.dart';
import '../../../../app/config/app_router.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../domain/entities/user_profile.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  // Demo profile — en producción cargar desde ProfileBloc + UseCase

  @override
  Widget build(BuildContext context) {
    final profile = UserProfile(
      id: '42', name: 'María García López',
      email: 'maria.garcia@email.com', phone: '+34 612 345 678',
      memberSince: DateTime(2023, 6, 15),
    );

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthUnauthenticated) context.go(AppRoutes.login);
      },
      child: Scaffold(
        backgroundColor: AppTheme.backgroundDark,
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              floating: true, snap: true,
              backgroundColor: AppTheme.backgroundDark,
              expandedHeight: 100,
              flexibleSpace: FlexibleSpaceBar(
                titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
                title: Text('Mi Perfil', style: GoogleFonts.inter(fontSize: 26, fontWeight: FontWeight.w700, color: Colors.white)),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    _buildAvatarCard(context, profile),
                    const SizedBox(height: 16),
                    _buildInfoCard(profile),
                    const SizedBox(height: 16),
                    _buildMenuSection(context),
                    const SizedBox(height: 16),
                    _buildLogoutButton(context),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatarCard(BuildContext context, UserProfile profile) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [AppTheme.primaryColor.withOpacity(0.15), AppTheme.cardColor], begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.primaryColor.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            width: 72, height: 72,
            decoration: BoxDecoration(
              gradient: AppTheme.primaryGradient,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [BoxShadow(color: AppTheme.primaryColor.withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 4))],
            ),
            child: Center(
              child: Text(
                profile.name.isNotEmpty ? profile.name[0].toUpperCase() : '?',
                style: GoogleFonts.inter(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w700),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(profile.name, style: GoogleFonts.inter(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                Text(profile.email, style: GoogleFonts.inter(color: AppTheme.textSecondary, fontSize: 13)),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppTheme.primaryColor.withOpacity(0.2)),
                  ),
                  child: Text('Cliente desde ${profile.memberSince.year}',
                      style: GoogleFonts.inter(color: AppTheme.primaryColor, fontSize: 11, fontWeight: FontWeight.w500)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(UserProfile profile) {
    return Container(
      decoration: BoxDecoration(color: AppTheme.cardColor, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppTheme.borderColor)),
      child: Column(
        children: [
          _InfoRow(icon: Icons.email_outlined, label: 'Email', value: profile.email),
          const Divider(height: 1, color: AppTheme.borderColor),
          _InfoRow(icon: Icons.phone_outlined, label: 'Teléfono', value: profile.phone),
        ],
      ),
    );
  }

  Widget _buildMenuSection(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: AppTheme.cardColor, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppTheme.borderColor)),
      child: Column(
        children: [
          _MenuTile(
            icon: Icons.pets,
            iconColor: AppTheme.primaryColor,
            label: 'Mis Mascotas',
            subtitle: 'Ver historial y citas',
            onTap: () => context.go(AppRoutes.pets),
          ),
          const Divider(height: 1, color: AppTheme.borderColor),
          _MenuTile(
            icon: Icons.calendar_today_outlined,
            iconColor: Colors.purple.shade300,
            label: 'Próximas Citas',
            subtitle: 'Ver mis citas veterinarias',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Próximamente disponible', style: GoogleFonts.inter()), backgroundColor: AppTheme.surfaceColor, behavior: SnackBarBehavior.floating),
              );
            },
          ),
          const Divider(height: 1, color: AppTheme.borderColor),
          _MenuTile(
            icon: Icons.shield_outlined,
            iconColor: Colors.blue.shade300,
            label: 'Privacidad',
            subtitle: 'Configuración de datos personales',
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return SizedBox(
      width: double.infinity, height: 52,
      child: OutlinedButton.icon(
        onPressed: () => _confirmLogout(context),
        icon: const Icon(Icons.logout, size: 18, color: AppTheme.errorColor),
        label: Text('Cerrar sesión', style: GoogleFonts.inter(color: AppTheme.errorColor, fontWeight: FontWeight.w600)),
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: AppTheme.errorColor.withOpacity(0.5)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
    );
  }

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Cerrar sesión', style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.w600)),
        content: Text('¿Estás seguro? Se eliminarán todos los datos de sesión del dispositivo de forma segura.', style: GoogleFonts.inter(color: AppTheme.textSecondary, height: 1.5)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text('Cancelar', style: GoogleFonts.inter(color: AppTheme.textSecondary))),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              // SEGURIDAD: purga SecureStorage completa vía AuthBloc
              context.read<AuthBloc>().add(const AuthLogoutRequested());
            },
            child: Text('Cerrar sesión', style: GoogleFonts.inter(color: AppTheme.errorColor, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _InfoRow({required this.icon, required this.label, required this.value});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.textSecondary, size: 18),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: GoogleFonts.inter(color: AppTheme.textSecondary, fontSize: 11)),
              Text(value, style: GoogleFonts.inter(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500)),
            ],
          ),
        ],
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String subtitle;
  final VoidCallback onTap;
  const _MenuTile({required this.icon, required this.iconColor, required this.label, required this.subtitle, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 38, height: 38,
              decoration: BoxDecoration(color: iconColor.withOpacity(0.12), borderRadius: BorderRadius.circular(10)),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14)),
                  Text(subtitle, style: GoogleFonts.inter(color: AppTheme.textSecondary, fontSize: 12)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppTheme.textSecondary, size: 20),
          ],
        ),
      ),
    );
  }
}
