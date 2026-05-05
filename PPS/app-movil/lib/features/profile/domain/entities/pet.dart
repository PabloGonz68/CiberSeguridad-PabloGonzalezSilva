// lib/features/profile/domain/entities/pet.dart
import 'package:equatable/equatable.dart';

class Pet extends Equatable {
  final String id;
  final String name;
  final String species;
  final String breed;
  final int ageMonths;
  final String gender;
  final String imageUrl;
  final DateTime? lastVisit;
  final String? nextAppointment;
  final List<String> vaccines;

  const Pet({
    required this.id,
    required this.name,
    required this.species,
    required this.breed,
    required this.ageMonths,
    required this.gender,
    this.imageUrl = '',
    this.lastVisit,
    this.nextAppointment,
    this.vaccines = const [],
  });

  String get ageLabel {
    if (ageMonths < 12) return '$ageMonths meses';
    final y = ageMonths ~/ 12;
    return '$y ${y == 1 ? 'año' : 'años'}';
  }

  @override
  List<Object?> get props => [id, name];
}
