import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'core/theme/app_theme.dart';
import 'features/pets/presentation/providers/pet_providers.dart';
import 'features/pets/presentation/screens/details/pet_detail_screen.dart';
import 'features/pets/presentation/screens/favorites/favorites_screen.dart';
import 'features/pets/presentation/screens/home/home_screen.dart';
import 'features/pets/presentation/screens/search/search_screen.dart';

class AdoptaAmorApp extends ConsumerWidget {
  const AdoptaAmorApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'AdoptaAmor',
      theme: AppTheme.lightTheme(),
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: HomeScreen.routeName,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/search',
        name: SearchScreen.routeName,
        builder: (context, state) => const SearchScreen(),
      ),
      GoRoute(
        path: '/favorites',
        name: FavoritesScreen.routeName,
        builder: (context, state) => const FavoritesScreen(),
      ),
      GoRoute(
        path: '/pet/:id',
        name: PetDetailScreen.routeName,
        builder: (context, state) {
          final petId = state.pathParameters['id']!;
          return PetDetailScreen(petId: petId);
        },
      ),
    ],
  );
});
