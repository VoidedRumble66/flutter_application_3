import 'package:flutter/material.dart';

import '../../domain/entities/pet.dart';

class PetHealthBadge extends StatelessWidget {
  const PetHealthBadge({super.key, required this.healthStatus});

  final PetHealthStatus healthStatus;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final badges = <Widget>[];

    if (healthStatus.isVaccinated) {
      badges.add(_buildChip(
        context,
        icon: Icons.vaccines,
        label: 'Vacunado',
        color: theme.colorScheme.secondary,
      ));
    }

    if (healthStatus.isNeutered) {
      badges.add(_buildChip(
        context,
        icon: Icons.health_and_safety,
        label: 'Esterilizado',
        color: theme.colorScheme.primary,
      ));
    }

    if (badges.isEmpty) {
      badges.add(_buildChip(
        context,
        icon: Icons.info_outline,
        label: 'Revisión pendiente',
        color: theme.colorScheme.outline,
      ));
    }

    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children: badges,
    );
  }

  Widget _buildChip(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Chip(
      visualDensity: VisualDensity.compact,
      avatar: Icon(icon, size: 16, color: color),
      label: Text(label),
      side: BorderSide(color: color.withOpacity(0.5)),
    );
  }
}
