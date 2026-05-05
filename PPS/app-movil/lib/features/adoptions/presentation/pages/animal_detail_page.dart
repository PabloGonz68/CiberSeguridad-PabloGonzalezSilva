// lib/features/adoptions/presentation/pages/animal_detail_page.dart
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../app/config/app_theme.dart';
import '../../domain/entities/animal.dart';

class AnimalDetailPage extends StatelessWidget {
  final String animalId;
  const AnimalDetailPage({super.key, required this.animalId});

  Animal _demo() => const Animal(
    id: '1', name: 'Bruno', species: 'Perro', breed: 'Labrador mix',
    ageMonths: 18, gender: 'Macho',
    description: 'Bruno llegó al refugio hace 3 meses tras ser encontrado en la calle. Es un perro muy sociable, cariñoso y activo. Se lleva bien con otros perros y con niños. Necesita una familia que pueda darle ejercicio diario y mucho amor. Está vacunado, desparasitado y esterilizado.',
    imageUrl: 'https://placehold.co/800x500/1C2128/00BFA5?text=Bruno',
    status: AdoptionStatus.available, vaccinated: true, sterilized: true, microchipped: true,
  );

  @override
  Widget build(BuildContext context) {
    final animal = _demo();
    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 280, pinned: true,
            backgroundColor: AppTheme.backgroundDark,
            leading: GestureDetector(
              onTap: () => context.pop(),
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(12)),
                child: const Icon(Icons.arrow_back, color: Colors.white),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: CachedNetworkImage(
                imageUrl: animal.imageUrl, fit: BoxFit.cover,
                errorWidget: (_, __, ___) => Container(color: AppTheme.surfaceColor, child: const Icon(Icons.pets, color: AppTheme.textSecondary, size: 60)),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(animal.name, style: GoogleFonts.inter(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w700)),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppTheme.successColor.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppTheme.successColor.withOpacity(0.4)),
                        ),
                        child: Text(animal.isAvailable ? 'Disponible' : 'Reservado',
                            style: GoogleFonts.inter(color: AppTheme.successColor, fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text('${animal.species} · ${animal.breed}',
                      style: GoogleFonts.inter(color: AppTheme.primaryColor, fontSize: 14)),
                  const SizedBox(height: 2),
                  Text('${animal.gender} · ${animal.ageLabel}',
                      style: GoogleFonts.inter(color: AppTheme.textSecondary, fontSize: 13)),
                  const SizedBox(height: 20),
                  // Estado sanitario
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceColor,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppTheme.borderColor),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Estado sanitario', style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14)),
                        const SizedBox(height: 12),
                        _SanitaryRow(label: 'Vacunado', active: animal.vaccinated, icon: Icons.vaccines),
                        _SanitaryRow(label: 'Esterilizado', active: animal.sterilized, icon: Icons.medical_services_outlined),
                        _SanitaryRow(label: 'Microchip', active: animal.microchipped, icon: Icons.radar),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text('Sobre ${animal.name}', style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16)),
                  const SizedBox(height: 8),
                  Text(animal.description, style: GoogleFonts.inter(color: AppTheme.textSecondary, fontSize: 14, height: 1.7)),
                  const SizedBox(height: 28),
                  // CTA adopción
                  if (animal.isAvailable) ...[
                    SizedBox(
                      width: double.infinity, height: 54,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: AppTheme.accentGradient,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [BoxShadow(color: AppTheme.accentColor.withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 4))],
                        ),
                        child: ElevatedButton.icon(
                          onPressed: () {
                            // TODO: Formulario de solicitud de adopción / abrir web
                            _showAdoptionDialog(context, animal.name);
                          },
                          icon: const Icon(Icons.favorite, size: 18),
                          label: Text('Solicitar adopción', style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 16)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent, shadowColor: Colors.transparent,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Center(
                      child: Text('El equipo de la clínica se pondrá en contacto contigo.',
                          style: GoogleFonts.inter(color: AppTheme.textSecondary, fontSize: 12)),
                    ),
                  ],
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAdoptionDialog(BuildContext context, String name) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Solicitar adopción de $name', style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.w600)),
        content: Text('Para completar la solicitud, accede a nuestra web o visítanos en clínica. Un veterinario revisará tu perfil y te contactará.', style: GoogleFonts.inter(color: AppTheme.textSecondary, height: 1.5)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text('Cerrar', style: GoogleFonts.inter(color: AppTheme.textSecondary))),
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text('Ir a la web', style: GoogleFonts.inter(color: AppTheme.primaryColor, fontWeight: FontWeight.w600))),
        ],
      ),
    );
  }
}

class _SanitaryRow extends StatelessWidget {
  final String label;
  final bool active;
  final IconData icon;
  const _SanitaryRow({required this.label, required this.active, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Icon(icon, size: 18, color: active ? AppTheme.successColor : AppTheme.textSecondary),
          const SizedBox(width: 10),
          Text(label, style: GoogleFonts.inter(color: AppTheme.textPrimary, fontSize: 13)),
          const Spacer(),
          Icon(active ? Icons.check_circle : Icons.cancel_outlined,
              size: 18, color: active ? AppTheme.successColor : AppTheme.errorColor),
        ],
      ),
    );
  }
}
