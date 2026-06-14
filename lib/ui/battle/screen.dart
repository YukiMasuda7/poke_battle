import 'package:flutter/material.dart';
import 'package:poke_battle/ui/battle/components/pokemon_option_button.dart';
import 'package:poke_battle/ui/battle/view_model.dart';

class BattleScreen extends StatefulWidget {
  const BattleScreen({super.key});

  @override
  State<BattleScreen> createState() => _BattleScreenState();
}

class _BattleScreenState extends State<BattleScreen> {
  late final BattleViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = BattleViewModel()..addListener(_onChanged);
  }

  @override
  void dispose() {
    _viewModel
      ..removeListener(_onChanged)
      ..dispose();
    super.dispose();
  }

  void _onChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ポケモンタイプじゃんけん')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: _buildBody(),
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_viewModel.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_viewModel.errorMessage != null) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('エラー: ${_viewModel.errorMessage}', textAlign: TextAlign.center),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: _viewModel.startBattle,
            child: const Text('再試行'),
          ),
        ],
      );
    }

    switch (_viewModel.step) {
      case BattleStep.start:
        return _buildStart();
      case BattleStep.select:
        return _buildSelect();
      case BattleStep.result:
        return _buildResult();
    }
  }

  Widget _buildStart() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'スタートでランダム4匹を取得\n自分3匹から1匹選んでタイプ勝負！',
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: _viewModel.startBattle,
          child: const Text('スタート'),
        ),
      ],
    );
  }

  Widget _buildSelect() {
    final enemy = _viewModel.enemyPokemon;
    if (enemy == null) {
      return _buildStart();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            _pokemonImage(enemy.imageUrl, 72),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                '相手: ${enemy.display}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        const Text('自分のポケモンを選んでください'),
        const SizedBox(height: 8),
        ..._viewModel.playerPokemons.map(
          (pokemon) => PokemonOptionButton(
            pokemon: pokemon,
            onPressed: () => _viewModel.choosePokemon(pokemon),
          ),
        ),
      ],
    );
  }

  Widget _buildResult() {
    final outcome = _viewModel.battleOutcome;
    if (outcome == null) {
      return _buildStart();
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '結果: ${outcome.label}',
          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                _pokemonImage(outcome.player.imageUrl, 96),
                const SizedBox(height: 4),
                Text('あなた: ${outcome.player.display}'),
              ],
            ),
            const SizedBox(width: 20),
            Column(
              children: [
                _pokemonImage(outcome.enemy.imageUrl, 96),
                const SizedBox(height: 4),
                Text('あいて: ${outcome.enemy.display}'),
              ],
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          '倍率 あなた ${outcome.playerMultiplier}x / 相手 ${outcome.enemyMultiplier}x',
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: _viewModel.startBattle,
          child: const Text('もう一回'),
        ),
      ],
    );
  }

  Widget _pokemonImage(String imageUrl, double size) {
    if (imageUrl.isEmpty) {
      return SizedBox(
        width: size,
        height: size,
        child: const Icon(Icons.catching_pokemon),
      );
    }

    return Image.network(
      imageUrl,
      width: size,
      height: size,
      fit: BoxFit.contain,
      errorBuilder: (_, _, _) {
        return SizedBox(
          width: size,
          height: size,
          child: const Icon(Icons.catching_pokemon),
        );
      },
    );
  }
}
