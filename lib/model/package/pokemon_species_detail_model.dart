class PokemonSpeciesDetailModel {
  const PokemonSpeciesDetailModel({
    required this.id,
    required this.nameJa,
    required this.imageUrl,
    required this.flavorTextJa,
  });

  final int id;
  final String nameJa;
  final String imageUrl;
  final String flavorTextJa;
}
