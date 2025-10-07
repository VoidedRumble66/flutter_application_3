import '../../domain/entities/pet.dart';
import '../../domain/entities/shelter.dart';
import '../../domain/repositories/pet_repository.dart';
import '../../domain/value_objects/pet_filters.dart';
import '../datasources/mock_pet_data_source.dart';

class MockPetRepository implements PetRepository {
  MockPetRepository(this._dataSource)
      : _pets = _dataSource.fetchPets(),
        _shelters = _dataSource.fetchShelters();

  final MockPetDataSource _dataSource;
  final List<Pet> _pets;
  final List<Shelter> _shelters;

  @override
  Future<List<Pet>> fetchPets() async {
    return _pets;
  }

  @override
  Future<List<Shelter>> fetchShelters() async {
    return _shelters;
  }

  @override
  Future<List<Pet>> searchPets(PetFilters filters) async {
    return _pets.where(filters.matches).toList();
  }

  @override
  Future<Pet?> getPetById(String id) async {
    try {
      return _pets.firstWhere((pet) => pet.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<Shelter?> getShelterById(String id) async {
    try {
      return _shelters.firstWhere((shelter) => shelter.id == id);
    } catch (_) {
      return null;
    }
  }
}
