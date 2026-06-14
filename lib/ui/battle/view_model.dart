import 'package:flutter/foundation.dart';
import 'package:poke_battle/model/package/battle_outcome_model.dart';
import 'package:poke_battle/model/package/pokemon_model.dart';
import 'package:poke_battle/model/search/type_relation_model.dart';
import 'package:poke_battle/provider/package/pokemon_provider.dart';
import 'package:poke_battle/provider/search/type_provider.dart';

enum BattleStep { start, select, result }

class BattleViewModel extends ChangeNotifier {
  BattleViewModel({
    PokemonProvider? pokemonProvider,
    TypeProvider? typeProvider,
  }) : _pokemonProvider = pokemonProvider ?? PokemonProvider(),
       _typeProvider = typeProvider ?? TypeProvider();

  final PokemonProvider _pokemonProvider;
  final TypeProvider _typeProvider;

  BattleStep step = BattleStep.start;
  bool isLoading = false;
  String? errorMessage;

  List<PokemonModel> playerPokemons = [];
  PokemonModel? enemyPokemon;
  BattleOutcomeModel? battleOutcome;

  Future<void> startBattle() async {
    isLoading = true;
    errorMessage = null;
    battleOutcome = null;
    notifyListeners();

    try {
      final candidates = await _pokemonProvider.fetchRandomPokemons(4);
      playerPokemons = candidates.sublist(0, 3);
      enemyPokemon = candidates[3];
      step = BattleStep.select;
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> choosePokemon(PokemonModel selected) async {
    final enemy = enemyPokemon;
    if (enemy == null) {
      return;
    }

    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final playerType = await _typeProvider.fetchTypeRelation(
        selected.primaryType,
      );
      final enemyType = await _typeProvider.fetchTypeRelation(
        enemy.primaryType,
      );

      final playerMultiplier = _calcMultiplier(playerType, enemy.primaryType);
      final enemyMultiplier = _calcMultiplier(enemyType, selected.primaryType);

      final result = _compare(playerMultiplier, enemyMultiplier);

      battleOutcome = BattleOutcomeModel(
        result: result,
        player: selected,
        enemy: enemy,
        playerMultiplier: playerMultiplier,
        enemyMultiplier: enemyMultiplier,
      );
      step = BattleStep.result;
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  BattleResult _compare(double player, double enemy) {
    if (player > enemy) {
      return BattleResult.win;
    }
    if (player < enemy) {
      return BattleResult.lose;
    }
    return BattleResult.draw;
  }

  double _calcMultiplier(TypeRelationModel relation, String defenderType) {
    if (relation.noDamageTo.contains(defenderType)) {
      return 0;
    }
    if (relation.doubleDamageTo.contains(defenderType)) {
      return 2;
    }
    if (relation.halfDamageTo.contains(defenderType)) {
      return 0.5;
    }
    return 1;
  }
}
