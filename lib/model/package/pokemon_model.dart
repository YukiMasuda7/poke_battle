class PokemonModel {
  const PokemonModel({
    required this.id,
    required this.name,
    required this.primaryType,
    required this.imageUrl,
  });

  final int id;
  final String name;
  final String primaryType;
  final String imageUrl;

  factory PokemonModel.fromJson(Map<String, dynamic> json) {
    final types = (json['types'] as List<dynamic>).cast<Map<String, dynamic>>()
      ..sort((a, b) => (a['slot'] as int).compareTo(b['slot'] as int));

    final type =
        (types.first['type'] as Map<String, dynamic>)['name'] as String;

    final sprites = json['sprites'] as Map<String, dynamic>?;
    final other = sprites?['other'] as Map<String, dynamic>?;
    final officialArtwork = other?['official-artwork'] as Map<String, dynamic>?;
    final imageUrl =
        (officialArtwork?['front_default'] as String?) ??
        (sprites?['front_default'] as String?) ??
        '';

    return PokemonModel(
      id: json['id'] as int,
      name: json['name'] as String,
      primaryType: type,
      imageUrl: imageUrl,
    );
  }

  String get display => '#$id $name ($primaryType)';
}
