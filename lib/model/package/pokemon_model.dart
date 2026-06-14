class PokemonModel {
  const PokemonModel({
    required this.id,
    required this.name,
    required this.nameJa,
    required this.primaryType,
    required this.imageUrl,
  });

  final int id;
  final String name;
  final String nameJa;
  final String primaryType;
  final String imageUrl;

  factory PokemonModel.fromJson(Map<String, dynamic> json) {
    final types = (json['types'] as List<dynamic>).cast<Map<String, dynamic>>()
      ..sort((a, b) => (a['slot'] as int).compareTo(b['slot'] as int));

    final primaryType =
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
      nameJa: json['name'] as String,
      primaryType: primaryType,
      imageUrl: imageUrl,
    );
  }

  PokemonModel copyWith({String? nameJa}) {
    return PokemonModel(
      id: id,
      name: name,
      nameJa: nameJa ?? this.nameJa,
      primaryType: primaryType,
      imageUrl: imageUrl,
    );
  }

  String get primaryTypeJa {
    switch (primaryType) {
      case 'normal':
        return 'ノーマル';
      case 'fire':
        return 'ほのお';
      case 'water':
        return 'みず';
      case 'electric':
        return 'でんき';
      case 'grass':
        return 'くさ';
      case 'ice':
        return 'こおり';
      case 'fighting':
        return 'かくとう';
      case 'poison':
        return 'どく';
      case 'ground':
        return 'じめん';
      case 'flying':
        return 'ひこう';
      case 'psychic':
        return 'エスパー';
      case 'bug':
        return 'むし';
      case 'rock':
        return 'いわ';
      case 'ghost':
        return 'ゴースト';
      case 'dragon':
        return 'ドラゴン';
      case 'dark':
        return 'あく';
      case 'steel':
        return 'はがね';
      case 'fairy':
        return 'フェアリー';
      default:
        return primaryType;
    }
  }

  String get display => '#$id $nameJa ($primaryTypeJa)';
}
