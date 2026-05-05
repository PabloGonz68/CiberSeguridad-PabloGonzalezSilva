// lib/features/adoptions/presentation/pages/adoptions_page.dart
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../app/config/app_theme.dart';
import '../../domain/entities/animal.dart';

class AdoptionsPage extends StatefulWidget {
  const AdoptionsPage({super.key});
  @override
  State<AdoptionsPage> createState() => _AdoptionsPageState();
}

class _AdoptionsPageState extends State<AdoptionsPage> {
  String _speciesFilter = 'Todos';
  final List<String> _speciesOptions = ['Todos', 'Perro', 'Gato', 'Conejo'];

  final List<Animal> _demoAnimals = const [
    Animal(id: '1', name: 'Bruno', species: 'Perro', breed: 'Labrador mix', ageMonths: 18, gender: 'Macho', description: 'Bruno es un perro juguetón y cariñoso que busca una familia activa. Le lleva 3 meses en el refugio.', imageUrl: 'https://placehold.co/600x400/1C2128/00BFA5?text=Bruno', status: AdoptionStatus.available, vaccinated: true, sterilized: true, microchipped: true),
    Animal(id: '2', name: 'Luna', species: 'Gato', breed: 'Europeo común', ageMonths: 8, gender: 'Hembra', description: 'Luna es una gatita tranquila y cariñosa. Se lleva bien con otros gatos. Ideal para piso.', imageUrl: 'https://placehold.co/600x400/1C2128/4DD0C4?text=Luna', status: AdoptionStatus.available, vaccinated: true, sterilized: true, microchipped: false),
    Animal(id: '3', name: 'Max', species: 'Perro', breed: 'Pastor Alemán', ageMonths: 36, gender: 'Macho', description: 'Max necesita un adoptante con experiencia. Muy inteligente y leal.', imageUrl: 'https://placehold.co/600x400/1C2128/FF7043?text=Max', status: AdoptionStatus.reserved, vaccinated: true, sterilized: false, microchipped: true),
    Animal(id: '4', name: 'Nieve', species: 'Conejo', breed: 'Enano holandés', ageMonths: 6, gender: 'Hembra', description: 'Nieve es una conejita adorable y muy sociable. Perfecta para familias con niños.', imageUrl: 'https://placehold.co/600x400/1C2128/4DD0C4?text=Nieve', status: AdoptionStatus.available, vaccinated: false, sterilized: false, microchipped: false),
    Animal(id: '5', name: 'Rocky', species: 'Perro', breed: 'Bulldog Francés', ageMonths: 24, gender: 'Macho', description: 'Rocky es tranquilo y se adapta bien a la vida en piso.', imageUrl: 'https://placehold.co/600x400/1C2128/00BFA5?text=Rocky', status: AdoptionStatus.available, vaccinated: true, sterilized: true, microchipped: true),
  ];

  List<Animal> get _filtered => _demoAnimals
      .where((a) => _speciesFilter == 'Todos' || a.species == _speciesFilter)
      .toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true, snap: true,
            backgroundColor: AppTheme.backgroundDark,
            expandedHeight: 100,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
              title: Text('Adopciones', style: GoogleFonts.inter(fontSize: 26, fontWeight: FontWeight.w700, color: Colors.white)),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.08),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppTheme.primaryColor.withOpacity(0.25)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.favorite, color: AppTheme.primaryColor, size: 20),
                  const SizedBox(width: 10),
                  Expanded(child: Text('${_filtered.where((a) => a.isAvailable).length} animales esperan un hogar. Contacta con nosotros para adoptar.', style: GoogleFonts.inter(color: AppTheme.textSecondary, fontSize: 13))),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 46,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                itemCount: _speciesOptions.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (_, i) {
                  final s = _speciesOptions[i];
                  final selected = s == _speciesFilter;
                  return GestureDetector(
                    onTap: () => setState(() => _speciesFilter = s),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                      decoration: BoxDecoration(
                        gradient: selected ? AppTheme.accentGradient : null,
                        color: selected ? null : AppTheme.surfaceColor,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: selected ? AppTheme.accentColor : AppTheme.borderColor),
                      ),
                      child: Text(s, style: GoogleFonts.inter(color: selected ? Colors.white : AppTheme.textSecondary, fontSize: 13, fontWeight: selected ? FontWeight.w600 : FontWeight.w400)),
                    ),
                  );
                },
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => _AnimalCard(animal: _filtered[index]),
                childCount: _filtered.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AnimalCard extends StatelessWidget {
  final Animal animal;
  const _AnimalCard({required this.animal});

  @override
  Widget build(BuildContext context) {
    final statusColor = switch (animal.status) {
      AdoptionStatus.available => AppTheme.successColor,
      AdoptionStatus.reserved  => Colors.orange,
      AdoptionStatus.adopted   => AppTheme.textSecondary,
    };
    final statusLabel = switch (animal.status) {
      AdoptionStatus.available => 'Disponible',
      AdoptionStatus.reserved  => 'Reservado',
      AdoptionStatus.adopted   => 'Adoptado',
    };
    return GestureDetector(
      onTap: () => context.go('/home/adoptions/${animal.id}'),
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(color: AppTheme.cardColor, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppTheme.borderColor)),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.horizontal(left: Radius.circular(16)),
              child: CachedNetworkImage(
                imageUrl: animal.imageUrl, width: 110, height: 118, fit: BoxFit.cover,
                errorWidget: (_, __, ___) => Container(width: 110, height: 118, color: AppTheme.surfaceColor, child: const Icon(Icons.pets, color: AppTheme.textSecondary, size: 36)),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(animal.name, style: GoogleFonts.inter(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(color: statusColor.withOpacity(0.12), borderRadius: BorderRadius.circular(6), border: Border.all(color: statusColor.withOpacity(0.3))),
                          child: Text(statusLabel, style: GoogleFonts.inter(color: statusColor, fontSize: 11, fontWeight: FontWeight.w600)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text('${animal.species} · ${animal.breed}', style: GoogleFonts.inter(color: AppTheme.primaryColor, fontSize: 12)),
                    Text('${animal.gender} · ${animal.ageLabel}', style: GoogleFonts.inter(color: AppTheme.textSecondary, fontSize: 12)),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 4, runSpacing: 4,
                      children: [
                        if (animal.vaccinated) _Badge('💉 Vacunado'),
                        if (animal.sterilized) _Badge('✂️ Esterilizado'),
                        if (animal.microchipped) _Badge('📡 Microchip'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;
  const _Badge(this.label);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(color: AppTheme.surfaceColor, borderRadius: BorderRadius.circular(4), border: Border.all(color: AppTheme.borderColor)),
      child: Text(label, style: GoogleFonts.inter(color: AppTheme.textSecondary, fontSize: 10)),
    );
  }
}
