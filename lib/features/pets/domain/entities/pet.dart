enum PetSpecies { dog, cat, rabbit, bird, other }

enum PetSize { small, medium, large }

enum PetGender { male, female }

class PetHealthStatus {
  const PetHealthStatus({
    required this.isVaccinated,
    required this.isNeutered,
  });

  final bool isVaccinated;
  final bool isNeutered;
}

class Pet {
  const Pet({
    required this.id,
    required this.name,
    required this.species,
    required this.breed,
    required this.age,
    required this.size,
    required this.gender,
    required this.description,
    required this.photoUrls,
    required this.healthStatus,
    required this.shelterId,
    required this.location,
  });

  final String id;
  final String name;
  final PetSpecies species;
  final String breed;
  final int age;
  final PetSize size;
  final PetGender gender;
  final String description;
  final List<String> photoUrls;
  final PetHealthStatus healthStatus;
  final String shelterId;
  final String location;
}
