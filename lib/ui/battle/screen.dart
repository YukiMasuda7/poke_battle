import 'package:flutter/material.dart';
import 'package:poke_battle/model/package/pokemon_model.dart';
import 'package:poke_battle/model/package/pokemon_species_detail_model.dart';
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
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFE53935),
              Color(0xFFE53935),
              Colors.black,
              Colors.black,
              Colors.white,
              Colors.white,
            ],
            stops: [0.0, 0.45, 0.45, 0.55, 0.55, 1.0],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 560),
              child: _buildBody(),
            ),
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
        const Text('スタートで勝負開始！', textAlign: TextAlign.center),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: _viewModel.startBattle,
          child: const Text('スタート'),
        ),
      ],
    );
  }

  Widget _buildSelect() {
    final enemies = _viewModel.enemyPokemons;
    if (enemies.isEmpty) {
      return _buildStart();
    }

    return Center(
      child: SizedBox(
        width: 460,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '相手ポケモン（この中からランダムで1匹が対戦）',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: enemies
                        .map((pokemon) => _enemyPreviewCard(pokemon))
                        .toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              '自分のポケモンを選んでください',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 14),
            ..._viewModel.playerPokemons.map(
              (pokemon) => PokemonOptionButton(
                pokemon: pokemon,
                onPressed: () => _viewModel.choosePokemon(pokemon),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _enemyPreviewCard(PokemonModel pokemon) {
    return Container(
      width: 128,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          _pokemonImage(pokemon.imageUrl, 64),
          const SizedBox(height: 4),
          Text(
            pokemon.display,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildResult() {
    final outcome = _viewModel.battleOutcome;
    if (outcome == null) {
      return _buildStart();
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '結果: ${outcome.label}',
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    _pokemonImage(outcome.player.imageUrl, 96),
                    const SizedBox(height: 4),
                    _buildPokemonDetailTrigger(
                      label: 'あなた',
                      pokemon: outcome.player,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  children: [
                    _pokemonImage(outcome.enemy.imageUrl, 96),
                    const SizedBox(height: 4),
                    _buildPokemonDetailTrigger(
                      label: 'あいて',
                      pokemon: outcome.enemy,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '倍率 あなた ${outcome.playerMultiplier}x / 相手 ${outcome.enemyMultiplier}x',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _viewModel.startBattle,
            child: const Text('もう一回'),
          ),
        ],
      ),
    );
  }

  Widget _buildPokemonDetailTrigger({
    required String label,
    required PokemonModel pokemon,
  }) {
    final linkColor = Theme.of(context).colorScheme.primary;

    return InkWell(
      onTap: () => _showPokemonSpeciesDialog(pokemon),
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        child: Column(
          children: [
            Text(
              '$label: ${pokemon.display}',
              textAlign: TextAlign.center,
              softWrap: true,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.menu_book, size: 16, color: linkColor),
                const SizedBox(width: 4),
                Text(
                  '図鑑説明を見る',
                  style: TextStyle(
                    color: linkColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showPokemonSpeciesDialog(PokemonModel pokemon) async {
    final detailFuture = _viewModel.fetchPokemonSpeciesDetail(pokemon);

    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('ポケモン図鑑'),
          content: FutureBuilder<PokemonSpeciesDetailModel>(
            future: detailFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const SizedBox(
                  width: 240,
                  height: 180,
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              if (snapshot.hasError || !snapshot.hasData) {
                return const SizedBox(
                  width: 240,
                  child: Text('図鑑情報を取得できませんでした。'),
                );
              }

              final detail = snapshot.data!;

              return SizedBox(
                width: 280,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _pokemonImage(detail.imageUrl, 120),
                    const SizedBox(height: 8),
                    Text('図鑑番号: ${detail.id}'),
                    const SizedBox(height: 4),
                    Text(
                      detail.nameJa,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Text(detail.flavorTextJa, textAlign: TextAlign.left),
                  ],
                ),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('閉じる'),
            ),
          ],
        );
      },
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
      errorBuilder: (_, _, _) => SizedBox(
        width: size,
        height: size,
        child: const Icon(Icons.catching_pokemon),
      ),
    );
  }
}
