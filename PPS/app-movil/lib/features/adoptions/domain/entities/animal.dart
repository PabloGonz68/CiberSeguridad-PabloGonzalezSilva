// lib/features/adoptions/domain/entities/animal.dart
import 'package:equatable/equatable.dart';

enum AdoptionStatus { available, reserved, adopted }

class Animal extends Equatable {
  final String id;
  final String name;
  final String species;   // Perro, Gato, Conejo, etc.
  final String breed;
  final int ageMonths;
  final String gender;    // Macho / Hembra
  final String description;
  final String imageUrl;
  final AdoptionStatus status;
  final bool vaccinated;
  final bool sterilized;
  final bool microchipped;
  final List<String> photos;

  const Animal({
    required this.id,
    required this.name,
    required this.species,
    required this.breed,
    required this.ageMonths,
    required this.gender,
    required this.description,
    required this.imageUrl,
    required this.status,
    required this.vaccinated,
    required this.sterilized,
    required this.microchipped,
    this.photos = const [],
  });

  String get ageLabel {
    if (ageMonths < 12) return '$ageMonths meses';
    final years = ageMonths ~/ 12;
    final months = ageMonths % 12;
    return months > 0 ? '$years años y $months meses' : '$years años';
  }

  bool get isAvailable => status == AdoptionStatus.available;

  @override
  List<Object?> get props => [id, name, status];
}
