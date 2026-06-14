class TypeRelationModel {
  const TypeRelationModel({
    required this.doubleDamageTo,
    required this.halfDamageTo,
    required this.noDamageTo,
  });

  final Set<String> doubleDamageTo;
  final Set<String> halfDamageTo;
  final Set<String> noDamageTo;

  factory TypeRelationModel.fromJson(Map<String, dynamic> json) {
    final relations = json['damage_relations'] as Map<String, dynamic>;

    Set<String> mapNames(String key) {
      final items = relations[key] as List<dynamic>;
      return items
          .map((item) => (item as Map<String, dynamic>)['name'] as String)
          .toSet();
    }

    return TypeRelationModel(
      doubleDamageTo: mapNames('double_damage_to'),
      halfDamageTo: mapNames('half_damage_to'),
      noDamageTo: mapNames('no_damage_to'),
    );
  }
}
