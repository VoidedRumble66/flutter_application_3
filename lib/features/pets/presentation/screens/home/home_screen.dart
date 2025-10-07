import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../domain/entities/pet.dart';
import '../../providers/pet_providers.dart';
import '../../widgets/pet_card.dart';
import '../favorites/favorites_screen.dart';
import '../details/pet_detail_screen.dart';
import '../search/search_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  static const String routeName = 'home';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final petsAsync = ref.watch(petListProvider);
    final favorites = ref.watch(favoritesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('AdoptaAmor'),
        actions: [
          IconButton(
            tooltip: 'Mis favoritos',
            icon: const Icon(Icons.favorite),
            onPressed: () => context.pushNamed(FavoritesScreen.routeName),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: GestureDetector(
                onTap: () => context.pushNamed(SearchScreen.routeName),
                child: Hero(
                  tag: 'search-bar',
                  child: Material(
                    color: Theme.of(context).colorScheme.surface,
                    elevation: 0,
                    borderRadius: BorderRadius.circular(16),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      child: Row(
                        children: [
                          Icon(Icons.search, color: Theme.of(context).colorScheme.outline),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Buscar mascotas por nombre, raza o ciudad',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(color: Theme.of(context).colorScheme.outline),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: petsAsync.when(
                data: (pets) => _PetGrid(
                  pets: pets,
                  favorites: favorites,
                ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => _ErrorView(onRetry: () {
                  ref.refresh(petListProvider);
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PetGrid extends ConsumerWidget {
  const _PetGrid({required this.pets, required this.favorites});

  final List<Pet> pets;
  final Set<String> favorites;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (pets.isEmpty) {
      return const Center(child: Text('No hay mascotas disponibles por ahora.'));
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        int crossAxisCount = 1;
        if (width > 1000) {
          crossAxisCount = 3;
        } else if (width > 600) {
          crossAxisCount = 2;
        }

        return GridView.builder(
          padding: const EdgeInsets.only(bottom: 24),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: crossAxisCount == 1 ? 1.05 : 0.85,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
          ),
          itemCount: pets.length,
          itemBuilder: (context, index) {
            final pet = pets[index];
            final isFavorite = favorites.contains(pet.id);
            return PetCard(
              pet: pet,
              isFavorite: isFavorite,
              onFavoriteToggle: () =>
                  ref.read(favoritesProvider.notifier).toggle(pet.id),
              onTap: () => context.pushNamed(
                PetDetailScreen.routeName,
                pathParameters: {'id': pet.id},
              ),
            );
          },
        );
      },
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Hubo un problema al cargar las mascotas.'),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: const Text('Reintentar'),
          ),
        ],
      ),
    );
  }
}
