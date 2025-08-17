import 'package:flutter/material.dart';
import '../models/pokemon.dart';

class PokemonTile extends StatelessWidget {
  final Pokemon pokemon;
  final bool isFavorite;
  final VoidCallback onFavoriteTap;

  const PokemonTile({
    super.key,
    required this.pokemon,
    required this.isFavorite,
    required this.onFavoriteTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.grey.shade200,
        backgroundImage: NetworkImage(pokemon.imageUrl),
      ),
      title: Text(pokemon.name.toUpperCase()),
      subtitle: Text('#${pokemon.id}'),
      trailing: IconButton(
        icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border, color: Colors.red),
        onPressed: onFavoriteTap,
      ),
    );
  }
}