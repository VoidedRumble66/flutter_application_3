import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/pet.dart';
import '../../../domain/entities/shelter.dart';
import '../../providers/pet_providers.dart';
import '../../widgets/pet_health_badge.dart';

class PetDetailScreen extends ConsumerStatefulWidget {
  const PetDetailScreen({super.key, required this.petId});

  static const String routeName = 'pet-detail';

  final String petId;

  @override
  ConsumerState<PetDetailScreen> createState() => _PetDetailScreenState();
}

class _PetDetailScreenState extends ConsumerState<PetDetailScreen> {
  late final PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final petAsync = ref.watch(petByIdProvider(widget.petId));

    return petAsync.when(
      data: (pet) {
        if (pet == null) {
          return const Scaffold(
            body: Center(child: Text('La mascota que buscas no existe.')),
          );
        }

        final isFavorite = ref.watch(favoritesProvider).contains(pet.id);
        final shelterAsync = ref.watch(shelterByIdProvider(pet.shelterId));

        return Scaffold(
          appBar: AppBar(
            title: Text(pet.name),
            actions: [
              IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                ),
                onPressed: () =>
                    ref.read(favoritesProvider.notifier).toggle(pet.id),
              ),
            ],
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildCarousel(context, pet),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          pet.name,
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${_speciesLabel(pet.species)} · ${pet.breed}',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 12,
                          runSpacing: 8,
                          children: [
                            Chip(
                              avatar: const Icon(Icons.cake, size: 18),
                              label: Text('${pet.age} años'),
                            ),
                            Chip(
                              avatar: const Icon(Icons.straighten, size: 18),
                              label: Text(_sizeLabel(pet.size)),
                            ),
                            Chip(
                              avatar: Icon(
                                pet.gender == PetGender.female
                                    ? Icons.female
                                    : Icons.male,
                                size: 18,
                              ),
                              label: Text(
                                pet.gender == PetGender.female ? 'Hembra' : 'Macho',
                              ),
                            ),
                            Chip(
                              avatar: const Icon(Icons.place, size: 18),
                              label: Text(pet.location),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        PetHealthBadge(healthStatus: pet.healthStatus),
                        const SizedBox(height: 24),
                        Text(
                          'Descripción',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          pet.description,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'Refugio',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 12),
                        shelterAsync.when(
                          data: (shelter) => _ShelterSection(shelter: shelter),
                          loading: () => const Center(child: CircularProgressIndicator()),
                          error: (error, stack) => const Text(
                            'No pudimos cargar la información del refugio.',
                          ),
                        ),
                        const SizedBox(height: 32),
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('¡Gracias por tu interés! Pronto un asesor te contactará.'),
                                ),
                              );
                            },
                            child: const Text('¡Adóptame!'),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => Scaffold(
        appBar: AppBar(),
        body: _ErrorContent(message: 'No pudimos cargar la mascota solicitada.'),
      ),
    );
  }

  Widget _buildCarousel(BuildContext context, Pet pet) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.35,
          width: double.infinity,
          child: PageView.builder(
            controller: _pageController,
            itemCount: pet.photoUrls.length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              final photoUrl = pet.photoUrls[index];
              return Hero(
                tag: index == 0 ? 'pet-image-${pet.id}' : 'pet-image-${pet.id}-$index',
                child: Image.network(
                  photoUrl,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) {
                      return child;
                    }
                    return Container(
                      color: Theme.of(context).colorScheme.surfaceVariant,
                      child: const Center(child: CircularProgressIndicator()),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Theme.of(context).colorScheme.surfaceVariant,
                      alignment: Alignment.center,
                      child: const Icon(Icons.pets, size: 72),
                    );
                  },
                ),
              );
            },
          ),
        ),
        if (pet.photoUrls.length > 1)
          Positioned(
            bottom: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black45,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  pet.photoUrls.length,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: _currentPage == index ? 12 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _currentPage == index
                          ? Colors.white
                          : Colors.white54,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  String _speciesLabel(PetSpecies species) {
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

  String _sizeLabel(PetSize size) {
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

class _ShelterSection extends StatelessWidget {
  const _ShelterSection({this.shelter});

  final Shelter? shelter;

  @override
  Widget build(BuildContext context) {
    if (shelter == null) {
      return const Text('Información del refugio no disponible.');
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              shelter!.name,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.place, size: 18),
                const SizedBox(width: 8),
                Expanded(child: Text(shelter!.location)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.phone, size: 18),
                const SizedBox(width: 8),
                Expanded(child: Text(shelter!.phone)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.email, size: 18),
                const SizedBox(width: 8),
                Expanded(child: Text(shelter!.email)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorContent extends StatelessWidget {
  const _ErrorContent({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(
          message,
          style: Theme.of(context).textTheme.bodyLarge,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
