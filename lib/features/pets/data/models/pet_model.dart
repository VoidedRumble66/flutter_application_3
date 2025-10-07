import '../../domain/entities/pet.dart';

class PetModel extends Pet {
  const PetModel({
    required super.id,
    required super.name,
    required super.species,
    required super.breed,
    required super.age,
    required super.size,
    required super.gender,
    required super.description,
    required super.photoUrls,
    required super.healthStatus,
    required super.shelterId,
    required super.location,
  });

  factory PetModel.fromMap(Map<String, dynamic> map) {
    return PetModel(
      id: map['id'] as String,
      name: map['name'] as String,
      species: _speciesFromString(map['species'] as String),
      breed: map['breed'] as String,
      age: map['age'] as int,
      size: _sizeFromString(map['size'] as String),
      gender: _genderFromString(map['gender'] as String),
      description: map['description'] as String,
      photoUrls: List<String>.from(map['photoUrls'] as List),
      healthStatus: PetHealthStatus(
        isVaccinated: map['isVaccinated'] as bool,
        isNeutered: map['isNeutered'] as bool,
      ),
      shelterId: map['shelterId'] as String,
      location: map['location'] as String,
    );
  }

  static PetSpecies _speciesFromString(String value) {
    switch (value.toLowerCase()) {
      case 'dog':
      case 'perro':
        return PetSpecies.dog;
      case 'cat':
      case 'gato':
        return PetSpecies.cat;
      case 'rabbit':
      case 'conejo':
        return PetSpecies.rabbit;
      case 'bird':
      case 'ave':
        return PetSpecies.bird;
      default:
        return PetSpecies.other;
    }
  }

  static PetSize _sizeFromString(String value) {
    switch (value.toLowerCase()) {
      case 'small':
      case 'pequeño':
        return PetSize.small;
      case 'medium':
      case 'mediano':
        return PetSize.medium;
      case 'large':
      case 'grande':
        return PetSize.large;
      default:
        return PetSize.medium;
    }
  }

  static PetGender _genderFromString(String value) {
    switch (value.toLowerCase()) {
      case 'male':
      case 'macho':
        return PetGender.male;
      case 'female':
      case 'hembra':
        return PetGender.female;
      default:
        return PetGender.female;
    }
  }
}
