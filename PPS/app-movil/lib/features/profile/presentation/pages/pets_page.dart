// lib/features/profile/presentation/pages/pets_page.dart
// Listado de mascotas del usuario con historial sanitario

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../app/config/app_theme.dart';
import '../../domain/entities/pet.dart';

class PetsPage extends StatelessWidget {
  const PetsPage({super.key});

  // Datos demo — reemplazar con ProfileBloc.pets
  static final List<Pet> _demoPets = [
    Pet(
      id: '1', name: 'Toby', species: 'Perro', breed: 'Golden Retriever',
      ageMonths: 48, gender: 'Macho',
      imageUrl: 'https://placehold.co/400x400/1C2128/00BFA5?text=Toby',
      lastVisit: DateTime(2026, 3, 10),
      nextAppointment: '15 Mayo 2026 – Revisión anual',
      vaccines: ['Rabia (2025)', 'Moquillo (2025)', 'Parvovirus (2025)', 'Hepatitis (2025)'],
    ),
    Pet(
      id: '2', name: 'Misi', species: 'Gato', breed: 'Persa',
      ageMonths: 30, gender: 'Hembra',
      imageUrl: 'https://placehold.co/400x400/1C2128/4DD0C4?text=Misi',
      lastVisit: DateTime(2026, 1, 22),
      nextAppointment: null,
      vaccines: ['Trivalente (2025)', 'Leucemia felina (2025)'],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      appBar: AppBar(
        backgroundColor: AppTheme.backgroundDark,
        leading: IconButton(onPressed: () => context.pop(), icon: const Icon(Icons.arrow_back, color: Colors.white)),
        title: Text('Mis Mascotas', style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.w700)),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _demoPets.length,
        itemBuilder: (context, index) => _PetCard(pet: _demoPets[index]),
      ),
    );
  }
}

class _PetCard extends StatefulWidget {
  final Pet pet;
  const _PetCard({required this.pet});
  @override
  State<_PetCard> createState() => _PetCardState();
}

class _PetCardState extends State<_PetCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final pet = widget.pet;
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Column(
        children: [
          // Header del card
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Avatar mascota
                Container(
                  width: 60, height: 60,
                  decoration: BoxDecoration(
                    gradient: AppTheme.primaryGradient,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: Text(
                      pet.species == 'Perro' ? '🐶' : pet.species == 'Gato' ? '🐱' : '🐾',
                      style: const TextStyle(fontSize: 28),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(pet.name, style: GoogleFonts.inter(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
                      Text('${pet.species} · ${pet.breed}', style: GoogleFonts.inter(color: AppTheme.primaryColor, fontSize: 12)),
                      Text('${pet.gender} · ${pet.ageLabel}', style: GoogleFonts.inter(color: AppTheme.textSecondary, fontSize: 12)),
                    ],
                  ),
                ),
                // Expandir/colapsar
                GestureDetector(
                  onTap: () => setState(() => _expanded = !_expanded),
                  child: AnimatedRotation(
                    turns: _expanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 250),
                    child: const Icon(Icons.keyboard_arrow_down, color: AppTheme.textSecondary),
                  ),
                ),
              ],
            ),
          ),
          // Próxima cita (siempre visible si existe)
          if (pet.nextAppointment != null) ...[
            const Divider(height: 1, color: AppTheme.borderColor),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  const Icon(Icons.calendar_today, color: AppTheme.accentColor, size: 16),
                  const SizedBox(width: 8),
                  Text('Próxima cita: ', style: GoogleFonts.inter(color: AppTheme.textSecondary, fontSize: 12)),
                  Expanded(child: Text(pet.nextAppointment!, style: GoogleFonts.inter(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600))),
                ],
              ),
            ),
          ],
          // Detalle expandible: última visita + vacunas
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: Column(
              children: [
                const Divider(height: 1, color: AppTheme.borderColor),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Última visita
                      Row(
                        children: [
                          const Icon(Icons.local_hospital_outlined, color: AppTheme.textSecondary, size: 16),
                          const SizedBox(width: 8),
                          Text('Última visita: ', style: GoogleFonts.inter(color: AppTheme.textSecondary, fontSize: 12)),
                          Text(
                            pet.lastVisit != null
                                ? '${pet.lastVisit!.day}/${pet.lastVisit!.month}/${pet.lastVisit!.year}'
                                : 'Sin registros',
                            style: GoogleFonts.inter(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      // Vacunas
                      Text('Historial de vacunas', style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13)),
                      const SizedBox(height: 8),
                      ...pet.vaccines.map((v) => Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Row(
                          children: [
                            const Icon(Icons.vaccines, color: AppTheme.successColor, size: 14),
                            const SizedBox(width: 8),
                            Text(v, style: GoogleFonts.inter(color: AppTheme.textSecondary, fontSize: 12)),
                          ],
                        ),
                      )),
                    ],
                  ),
                ),
              ],
            ),
            crossFadeState: _expanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 250),
          ),
        ],
      ),
    );
  }
}
