import '../entities/pet.dart';
import '../entities/shelter.dart';
import '../value_objects/pet_filters.dart';

abstract class PetRepository {
  Future<List<Pet>> fetchPets();
  Future<List<Shelter>> fetchShelters();
  Future<List<Pet>> searchPets(PetFilters filters);
  Future<Pet?> getPetById(String id);
  Future<Shelter?> getShelterById(String id);
}
