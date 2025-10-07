import 'package:flutter/material.dart';

import '../../domain/entities/pet.dart';
import 'pet_health_badge.dart';

class PetCard extends StatelessWidget {
  const PetCard({
    super.key,
    required this.pet,
    required this.isFavorite,
    required this.onFavoriteToggle,
    required this.onTap,
  });

  final Pet pet;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: 4 / 3,
                  child: Hero(
                    tag: 'pet-image-${pet.id}',
                    child: Image.network(
                      pet.photoUrls.first,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) {
                          return child;
                        }
                        return Container(
                          color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
                          child: const Center(child: CircularProgressIndicator()),
                        );
                      },
                      errorBuilder: (context, _, __) {
                        return Container(
                          color: theme.colorScheme.surfaceVariant,
                          alignment: Alignment.center,
                          child: const Icon(Icons.pets, size: 48),
                        );
                      },
                    ),
                  ),
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: Material(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(24),
                    child: IconButton(
                      icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite
                            ? theme.colorScheme.secondary
                            : theme.colorScheme.onSurface,
                      ),
                      onPressed: onFavoriteToggle,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pet.name,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text('${pet.breed} · ${pet.age} años'),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: [
                      Chip(
                        avatar: const Icon(Icons.place, size: 16),
                        label: Text(pet.location),
                        visualDensity: VisualDensity.compact,
                      ),
                      Chip(
                        avatar: const Icon(Icons.straighten, size: 16),
                        label: Text(_sizeLabel(pet.size)),
                        visualDensity: VisualDensity.compact,
                      ),
                      Chip(
                        avatar: Icon(_genderIcon(pet.gender), size: 16),
                        label: Text(_genderLabel(pet.gender)),
                        visualDensity: VisualDensity.compact,
                      ),
                      PetHealthBadge(healthStatus: pet.healthStatus),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
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

  String _genderLabel(PetGender gender) {
    switch (gender) {
      case PetGender.male:
        return 'Macho';
      case PetGender.female:
        return 'Hembra';
    }
  }

  IconData _genderIcon(PetGender gender) {
    switch (gender) {
      case PetGender.male:
        return Icons.male;
      case PetGender.female:
        return Icons.female;
    }
  }
}
