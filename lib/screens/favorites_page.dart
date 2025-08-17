import 'package:flutter/material.dart';
import 'package:flutter_application_1/providers/favorites_provider.dart';
import 'package:provider/provider.dart';

import '../widgets/pokemon_tile.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final fav = context.watch<FavoritesProvider>();
    final list = fav.asList;

    return Scaffold(
      appBar: AppBar(title: const Text('Favorites')),
      body: list.isEmpty
          ? const Center(child: Text('No favorites yet'))
          : ListView.builder(
              itemCount: list.length,
              itemBuilder: (context, i) {
                final p = list[i];
                return PokemonTile(
                  pokemon: p,
                  isFavorite: true,
                  onFavoriteTap: () => fav.toggle(p),
                );
              },
            ),
    );
  }
}