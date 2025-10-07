import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../domain/entities/pet.dart';
import '../../providers/pet_providers.dart';
import '../../widgets/pet_card.dart';
import '../details/pet_detail_screen.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  static const String routeName = 'search';

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    final filters = ref.read(petFiltersProvider);
    _searchController = TextEditingController(text: filters.query ?? '');
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final petsAsync = ref.watch(petListProvider);
    final filteredPetsAsync = ref.watch(filteredPetsProvider);
    final filters = ref.watch(petFiltersProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Buscar mascotas'),
        actions: [
          TextButton.icon(
            onPressed: () {
              ref.read(petFiltersProvider.notifier).reset();
              _searchController.clear();
            },
            icon: const Icon(Icons.clear_all),
            label: const Text('Limpiar'),
          ),
        ],
      ),
      body: SafeArea(
        child: petsAsync.when(
          data: (pets) {
            if (pets.isEmpty) {
              return const Center(child: Text('Aún no hay mascotas registradas.'));
            }

            final speciesOptions = _buildSpeciesOptions(pets);
            final breedOptions = _buildBreedOptions(pets, filters.species);
            final locationOptions = _buildLocationOptions(pets);
            final minAge = pets.map((pet) => pet.age).reduce(min);
            final maxAge = pets.map((pet) => pet.age).reduce(max);
            final sliderValues = RangeValues(
              (filters.ageRange?.$1 ?? minAge).toDouble(),
              (filters.ageRange?.$2 ?? maxAge).toDouble(),
            );

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                  child: Hero(
                    tag: 'search-bar',
                    child: Material(
                      borderRadius: BorderRadius.circular(16),
                      color: Theme.of(context).colorScheme.surface,
                      child: TextField(
                        controller: _searchController,
                        decoration: const InputDecoration(
                          hintText: 'Buscar por nombre, raza o ciudad',
                          prefixIcon: Icon(Icons.search),
                        ),
                        onChanged:
                            ref.read(petFiltersProvider.notifier).setQuery,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: CustomScrollView(
                    slivers: [
                      SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        sliver: SliverToBoxAdapter(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Filtros',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 12),
                              DropdownButtonFormField<PetSpecies?>(
                                value: filters.species,
                                decoration: const InputDecoration(
                                  labelText: 'Especie',
                                ),
                                items: [
                                  const DropdownMenuItem(
                                    value: null,
                                    child: Text('Todas las especies'),
                                  ),
                                  ...speciesOptions.map(
                                    (species) => DropdownMenuItem(
                                      value: species,
                                      child: Text(_speciesLabel(species)),
                                    ),
                                  ),
                                ],
                                onChanged: (value) => ref
                                    .read(petFiltersProvider.notifier)
                                    .setSpecies(value),
                              ),
                              const SizedBox(height: 12),
                              DropdownButtonFormField<String?>(
                                value: filters.breed,
                                decoration: const InputDecoration(
                                  labelText: 'Raza',
                                ),
                                items: [
                                  const DropdownMenuItem(
                                    value: null,
                                    child: Text('Todas las razas'),
                                  ),
                                  ...breedOptions.map(
                                    (breed) => DropdownMenuItem(
                                      value: breed,
                                      child: Text(breed),
                                    ),
                                  ),
                                ],
                                onChanged: (value) => ref
                                    .read(petFiltersProvider.notifier)
                                    .setBreed(value),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Tamaño',
                                style: Theme.of(context).textTheme.labelLarge,
                              ),
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 8,
                                children: PetSize.values
                                    .map(
                                      (size) => ChoiceChip(
                                        label: Text(_sizeLabel(size)),
                                        selected: filters.size == size,
                                        onSelected: (selected) => ref
                                            .read(petFiltersProvider.notifier)
                                            .setSize(selected ? size : null),
                                      ),
                                    )
                                    .toList(),
                              ),
                              const SizedBox(height: 12),
                              DropdownButtonFormField<String?>(
                                value: filters.location,
                                decoration: const InputDecoration(
                                  labelText: 'Ubicación',
                                ),
                                items: [
                                  const DropdownMenuItem(
                                    value: null,
                                    child: Text('Todas las ubicaciones'),
                                  ),
                                  ...locationOptions.map(
                                    (location) => DropdownMenuItem(
                                      value: location,
                                      child: Text(location),
                                    ),
                                  ),
                                ],
                                onChanged: (value) => ref
                                    .read(petFiltersProvider.notifier)
                                    .setLocation(value),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Edad (años)',
                                style: Theme.of(context).textTheme.labelLarge,
                              ),
                              RangeSlider(
                                values: sliderValues,
                                min: minAge.toDouble(),
                                max: maxAge.toDouble(),
                                divisions:
                                    maxAge == minAge ? null : maxAge - minAge,
                                labels: RangeLabels(
                                  '${sliderValues.start.round()} años',
                                  '${sliderValues.end.round()} años',
                                ),
                                onChanged: (values) {
                                  final start = values.start.round();
                                  final end = values.end.round();
                                  if (start <= minAge && end >= maxAge) {
                                    ref
                                        .read(petFiltersProvider.notifier)
                                        .setAgeRange(null);
                                  } else {
                                    ref
                                        .read(petFiltersProvider.notifier)
                                        .setAgeRange((start, end));
                                  }
                                },
                              ),
                              const SizedBox(height: 16),
                              Divider(color: Theme.of(context).colorScheme.outline),
                            ],
                          ),
                        ),
                      ),
                      SliverPadding(
                        padding: const EdgeInsets.fromLTRB(8, 8, 8, 24),
                        sliver: filteredPetsAsync.when(
                          data: (results) {
                            if (results.isEmpty) {
                              return const SliverFillRemaining(
                                hasScrollBody: false,
                                child: Center(
                                  child: Text(
                                    'No encontramos coincidencias con tus filtros. ¡Prueba ajustarlos!',
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              );
                            }
                            return SliverGrid(
                              delegate: SliverChildBuilderDelegate(
                                (context, index) {
                                  final pet = results[index];
                                  final isFavorite = ref
                                      .watch(favoritesProvider)
                                      .contains(pet.id);
                                  return PetCard(
                                    pet: pet,
                                    isFavorite: isFavorite,
                                    onFavoriteToggle: () => ref
                                        .read(favoritesProvider.notifier)
                                        .toggle(pet.id),
                                    onTap: () => context.pushNamed(
                                      PetDetailScreen.routeName,
                                      pathParameters: {'id': pet.id},
                                    ),
                                  );
                                },
                                childCount: results.length,
                              ),
                              gridDelegate:
                                  const SliverGridDelegateWithMaxCrossAxisExtent(
                                maxCrossAxisExtent: 520,
                                mainAxisSpacing: 8,
                                crossAxisSpacing: 8,
                                childAspectRatio: 1.05,
                              ),
                            );
                          },
                          loading: () => const SliverFillRemaining(
                            hasScrollBody: false,
                            child: Center(child: CircularProgressIndicator()),
                          ),
                          error: (error, stack) => SliverFillRemaining(
                            hasScrollBody: false,
                            child: _SearchError(error: error, stack: stack),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) => _SearchError(error: error, stack: stackTrace),
        ),
      ),
    );
  }

  List<PetSpecies> _buildSpeciesOptions(List<Pet> pets) {
    final set = {
      for (final pet in pets) pet.species,
    };
    return set.toList()..sort((a, b) => _speciesLabel(a).compareTo(_speciesLabel(b)));
  }

  List<String> _buildBreedOptions(List<Pet> pets, PetSpecies? species) {
    final breeds = pets
        .where((pet) => species == null || pet.species == species)
        .map((pet) => pet.breed)
        .toSet()
        .toList()
      ..sort();
    return breeds;
  }

  List<String> _buildLocationOptions(List<Pet> pets) {
    final locations = pets.map((pet) => pet.location).toSet().toList()..sort();
    return locations;
  }

  static String _speciesLabel(PetSpecies species) {
    switch (species) {
      case PetSpecies.dog:
        return 'Perro';
      case PetSpecies.cat:
        return 'Gato';
      case PetSpecies.rabbit:
        return 'Conejo';
      case PetSpecies.bird:
        return 'Ave';
      case PetSpecies.other:
        return 'Otro';
    }
  }

  static String _sizeLabel(PetSize size) {
    switch (size) {
      case PetSize.small:
        return 'Pequeño';
      case PetSize.medium:
        return 'Mediano';
      case PetSize.large:
        return 'Grande';
    }
  }
}

class _SearchError extends StatelessWidget {
  const _SearchError({required this.error, required this.stack});

  final Object error;
  final StackTrace stack;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.sentiment_dissatisfied, size: 48),
          const SizedBox(height: 12),
          Text(
            'Ocurrió un error inesperado. Intenta nuevamente.',
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            '$error',
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
