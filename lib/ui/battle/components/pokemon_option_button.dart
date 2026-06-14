import 'package:flutter/material.dart';
import 'package:poke_battle/model/package/pokemon_model.dart';

class PokemonOptionButton extends StatelessWidget {
  const PokemonOptionButton({
    super.key,
    required this.pokemon,
    required this.onPressed,
  });

  final PokemonModel pokemon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          backgroundColor: Theme.of(
            context,
          ).colorScheme.surfaceContainerHighest,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        onPressed: onPressed,
        child: Row(
          children: [
            _PokemonImage(imageUrl: pokemon.imageUrl, size: 48),
            const SizedBox(width: 12),
            Expanded(child: Text(pokemon.display)),
          ],
        ),
      ),
    );
  }
}

class _PokemonImage extends StatelessWidget {
  const _PokemonImage({required this.imageUrl, required this.size});

  final String imageUrl;
  final double size;

  @override
  Widget build(BuildContext context) {
    if (imageUrl.isEmpty) {
      return _fallback(size);
    }

    return Image.network(
      imageUrl,
      width: size,
      height: size,
      fit: BoxFit.contain,
      errorBuilder: (_, _, _) => _fallback(size),
    );
  }

  Widget _fallback(double size) {
    return SizedBox(
      width: size,
      height: size,
      child: const Icon(Icons.catching_pokemon),
    );
  }
}
