import '../entities/pet.dart';

class PetFilters {
  const PetFilters({
    this.query,
    this.species,
    this.breed,
    this.size,
    this.location,
    this.ageRange,
  });

  final String? query;
  final PetSpecies? species;
  final String? breed;
  final PetSize? size;
  final String? location;
  final (int min, int max)? ageRange;

  PetFilters copyWith({
    String? query,
    bool clearQuery = false,
    PetSpecies? species,
    bool clearSpecies = false,
    String? breed,
    bool clearBreed = false,
    PetSize? size,
    bool clearSize = false,
    String? location,
    bool clearLocation = false,
    (int min, int max)? ageRange,
    bool clearAgeRange = false,
  }) {
    return PetFilters(
      query: clearQuery ? null : query ?? this.query,
      species: clearSpecies ? null : species ?? this.species,
      breed: clearBreed ? null : breed ?? this.breed,
      size: clearSize ? null : size ?? this.size,
      location: clearLocation ? null : location ?? this.location,
      ageRange: clearAgeRange ? null : ageRange ?? this.ageRange,
    );
  }

  bool matches(Pet pet) {
    if (query != null && query!.isNotEmpty) {
      final lower = query!.toLowerCase();
      final haystack = '${pet.name} ${pet.breed} ${pet.description}'.toLowerCase();
      if (!haystack.contains(lower)) {
        return false;
      }
    }
    if (species != null && pet.species != species) {
      return false;
    }
    if (breed != null && breed!.isNotEmpty && pet.breed != breed) {
      return false;
    }
    if (size != null && pet.size != size) {
      return false;
    }
    if (location != null && location!.isNotEmpty && pet.location != location) {
      return false;
    }
    if (ageRange != null) {
      if (pet.age < ageRange!.$1 || pet.age > ageRange!.$2) {
        return false;
      }
    }
    return true;
  }
}
