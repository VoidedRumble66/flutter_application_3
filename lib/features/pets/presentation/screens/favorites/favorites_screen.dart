import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../domain/entities/pet.dart';
import '../../providers/pet_providers.dart';
import '../../widgets/pet_card.dart';
import '../details/pet_detail_screen.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  static const String routeName = 'favorites';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoritePetsAsync = ref.watch(favoritePetsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis favoritos'),
        actions: [
          IconButton(
            tooltip: 'Limpiar favoritos',
            icon: const Icon(Icons.delete_outline),
            onPressed: () {
              ref.read(favoritesProvider.notifier).clear();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Se vació tu lista de favoritos.')),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: favoritePetsAsync.when(
          data: (pets) => _FavoritesList(pets: pets),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(
            child: Text('No se pudieron cargar tus favoritos: $error'),
          ),
        ),
      ),
    );
  }
}

class _FavoritesList extends ConsumerWidget {
  const _FavoritesList({required this.pets});

  final List<Pet> pets;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (pets.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'Aún no agregas mascotas a favoritos. Toca el corazón en una ficha para guardarla.',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      itemCount: pets.length,
      itemBuilder: (context, index) {
        final pet = pets[index];
        return PetCard(
          pet: pet,
          isFavorite: true,
          onFavoriteToggle: () =>
              ref.read(favoritesProvider.notifier).toggle(pet.id),
          onTap: () => context.pushNamed(
            PetDetailScreen.routeName,
            pathParameters: {'id': pet.id},
          ),
        );
      },
    );
  }
}
