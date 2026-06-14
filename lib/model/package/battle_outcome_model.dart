import 'package:poke_battle/model/package/pokemon_model.dart';

enum BattleResult { win, lose, draw }

class BattleOutcomeModel {
  const BattleOutcomeModel({
    required this.result,
    required this.player,
    required this.enemy,
    required this.playerMultiplier,
    required this.enemyMultiplier,
  });

  final BattleResult result;
  final PokemonModel player;
  final PokemonModel enemy;
  final double playerMultiplier;
  final double enemyMultiplier;

  String get label {
    switch (result) {
      case BattleResult.win:
        return '勝ち';
      case BattleResult.lose:
        return '負け';
      case BattleResult.draw:
        return '引き分け';
    }
  }
}
