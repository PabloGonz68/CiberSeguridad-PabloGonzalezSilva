// lib/features/adoptions/data/models/animal_model.dart
import '../../domain/entities/animal.dart';

class AnimalModel extends Animal {
  const AnimalModel({
    required super.id,
    required super.name,
    required super.species,
    required super.breed,
    required super.ageMonths,
    required super.gender,
    required super.description,
    required super.imageUrl,
    required super.status,
    required super.vaccinated,
    required super.sterilized,
    required super.microchipped,
    super.photos,
  });

  factory AnimalModel.fromJson(Map<String, dynamic> json) {
    AdoptionStatus parseStatus(dynamic raw) {
      switch (raw?.toString().toLowerCase()) {
        case 'reserved':
        case 'reservado':
          return AdoptionStatus.reserved;
        case 'adopted':
        case 'adoptado':
          return AdoptionStatus.adopted;
        default:
          return AdoptionStatus.available;
      }
    }

    return AnimalModel(
      id: json['id'].toString(),
      name: json['name'] as String? ?? '',
      species: json['species'] as String? ?? json['tipo'] as String? ?? '',
      breed: json['breed'] as String? ?? json['raza'] as String? ?? '',
      ageMonths: json['age_months'] as int? ?? json['edad_meses'] as int? ?? 0,
      gender: json['gender'] as String? ?? json['sexo'] as String? ?? '',
      description: json['description'] as String? ?? json['descripcion'] as String? ?? '',
      imageUrl: json['image_url'] as String? ?? json['imagen'] as String? ?? '',
      status: parseStatus(json['status'] ?? json['estado']),
      vaccinated: json['vaccinated'] as bool? ?? json['vacunado'] as bool? ?? false,
      sterilized: json['sterilized'] as bool? ?? json['esterilizado'] as bool? ?? false,
      microchipped: json['microchipped'] as bool? ?? json['microchip'] as bool? ?? false,
      photos: (json['photos'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }
}
