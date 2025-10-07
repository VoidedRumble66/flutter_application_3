import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../pets/data/datasources/mock_pet_data_source.dart';
import '../../../pets/data/repositories/mock_pet_repository.dart';
import '../../../pets/domain/entities/pet.dart';
import '../../../pets/domain/entities/shelter.dart';
import '../../../pets/domain/repositories/pet_repository.dart';
import '../../../pets/domain/value_objects/pet_filters.dart';

final petRepositoryProvider = Provider<PetRepository>((ref) {
  return MockPetRepository(const MockPetDataSource());
});

final petListProvider = FutureProvider<List<Pet>>((ref) async {
  final repository = ref.watch(petRepositoryProvider);
  return repository.fetchPets();
});

final shelterListProvider = FutureProvider<List<Shelter>>((ref) async {
  final repository = ref.watch(petRepositoryProvider);
  return repository.fetchShelters();
});

final petByIdProvider = FutureProvider.family<Pet?, String>((ref, id) async {
  final repository = ref.watch(petRepositoryProvider);
  return repository.getPetById(id);
});

final shelterByIdProvider = FutureProvider.family<Shelter?, String>((ref, id) async {
  final repository = ref.watch(petRepositoryProvider);
  return repository.getShelterById(id);
});

class PetFiltersNotifier extends StateNotifier<PetFilters> {
  PetFiltersNotifier() : super(const PetFilters());

  void setQuery(String? value) {
    if (value == null || value.isEmpty) {
      state = state.copyWith(clearQuery: true);
    } else {
      state = state.copyWith(query: value.trim());
    }
  }

  void setSpecies(PetSpecies? species) {
    state = state.copyWith(
      species: species,
      clearSpecies: species == null,
      breed: null,
      clearBreed: species == null,
    );
  }

  void setBreed(String? breed) {
    if (breed == null || breed.isEmpty) {
      state = state.copyWith(clearBreed: true);
    } else {
      state = state.copyWith(breed: breed);
    }
  }

  void setSize(PetSize? size) {
    state = state.copyWith(size: size, clearSize: size == null);
  }

  void setLocation(String? location) {
    if (location == null || location.isEmpty) {
      state = state.copyWith(clearLocation: true);
    } else {
      state = state.copyWith(location: location);
    }
  }

  void setAgeRange((int min, int max)? range) {
    if (range == null) {
      state = state.copyWith(clearAgeRange: true);
    } else {
      state = state.copyWith(ageRange: range);
    }
  }

  void reset() {
    state = const PetFilters();
  }
}

final petFiltersProvider =
    StateNotifierProvider<PetFiltersNotifier, PetFilters>((ref) {
  return PetFiltersNotifier();
});

final filteredPetsProvider = Provider<AsyncValue<List<Pet>>>((ref) {
  final filters = ref.watch(petFiltersProvider);
  final pets = ref.watch(petListProvider);
  return pets.whenData((list) => list.where(filters.matches).toList());
});

class FavoritesNotifier extends StateNotifier<Set<String>> {
  FavoritesNotifier() : super(<String>{});

  bool isFavorite(String petId) => state.contains(petId);

  void toggle(String petId) {
    if (state.contains(petId)) {
      state = {...state}..remove(petId);
    } else {
      state = {...state, petId};
    }
  }

  void clear() {
    state = <String>{};
  }
}

final favoritesProvider =
    StateNotifierProvider<FavoritesNotifier, Set<String>>((ref) {
  return FavoritesNotifier();
});

final favoritePetsProvider = Provider<AsyncValue<List<Pet>>>((ref) {
  final favorites = ref.watch(favoritesProvider);
  final pets = ref.watch(petListProvider);
  return pets.whenData(
    (list) => list.where((pet) => favorites.contains(pet.id)).toList(),
  );
});
