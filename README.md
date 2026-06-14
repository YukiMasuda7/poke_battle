# poke_battle

PokeAPI を使った「ポケモンのタイプ相性じゃんけん」アプリです。  
ランダムに選ばれたポケモンで、タイプ相性にもとづいて勝敗を判定します。

## アプリ概要

- 自分の手持ちポケモン: ランダム 3 匹
- 相手ポケモン: ランダム 3 匹（表示）
- 対戦相手: 相手候補 3 匹の中からランダム 1 匹（自動選出）
- 勝負方法: タイプ相性（単一タイプ判定）
- 複数タイプのポケモン: `type1`（`slot: 1`）のみ使用
- 表示: ポケモン名・タイプ名は日本語表示（可能な範囲）

## 操作方法

1. **スタート画面**で `スタート` を押す
2. PokeAPI からポケモン 6 匹をランダム取得（自分のポケモン 3 + 相手のポケモン 3）
3. **選択画面**で相手ポケモン 3 匹を表示しつつ、自分のポケモン 3 匹から 1 匹を選ぶ
4. 自分を選んだタイミングで、相手ポケモン 3 匹からランダム 1 匹が自動選出
5. **結果画面**で勝ち / 負け / 引き分けを表示
6. `もう一回` を押すと、2に戻る

## 勝ち負けの判定方法

### 1) 取得データ

- ポケモン情報: `GET https://pokeapi.co/api/v2/pokemon/{id}`
- タイプ相性: `GET https://pokeapi.co/api/v2/type/{type}`

### 2) 判定に使う値

`/type/{type}` の `damage_relations` を使用します。

- `double_damage_to` → 倍率 `2.0`
- `half_damage_to` → 倍率 `0.5`
- `no_damage_to` → 倍率 `0.0`
- それ以外 → 倍率 `1.0`

### 3) 勝敗決定

まず相手のポケモン 3 匹からランダムで 1 匹が選ばれ、そのポケモンと自分のポケモンを対戦させます。

- 自分の倍率 > 相手の倍率 → **勝ち**
- 自分の倍率 < 相手の倍率 → **負け**
- 同じ → **引き分け**

## 画面構成

- `start`: スタートボタン表示
- `select`: 相手候補 3 匹表示 + 自分のポケモン選択
- `result`: 自動選出された相手1匹との勝敗結果 + 倍率 + 再戦ボタン

## フォルダ構成

このプロジェクトは、以下の粒度で責務分割しています。

```text
lib/
	ui/
		battle/
			screen.dart
			view_model.dart
			components/
	provider/
		dio/
		search/
		package/
	model/
		search/
		package/
	router/
```

- `ui/`: 画面と画面部品
- `view_model.dart`: 画面で使う state と操作
- `provider/`: API クライアントと API 呼び出し
- `model/`: API レスポンスを扱う型
- `router/`: 画面遷移

## `lib/` ファイルごとの役割

### エントリ / ルーティング

- `lib/main.dart`
	- アプリのエントリポイント。
	- `MyApp` を起動し、`AppRouter` に処理を委譲します。

- `lib/router/app_router.dart`
	- `MaterialApp` の設定（テーマ・タイトル）と初期画面を定義します。
	- 初期画面として `BattleScreen` を表示します。

### 画面（UI）

- `lib/ui/battle/screen.dart`
	- バトル画面本体。
	- `start / select / result` の表示切り替えと、ユーザー操作の受け口を担当します。

- `lib/ui/battle/components/pokemon_option_button.dart`
	- 自分のポケモン選択用ボタン部品。
	- 画像・名前・タイプの表示とタップイベントを提供します。

- `lib/ui/battle/view_model.dart`
	- 画面状態（`BattleStep`, `isLoading`, `errorMessage` など）を管理。
	- バトル開始、ポケモン選択、勝敗判定呼び出しなどの操作ロジックを持ちます。

### Provider（APIアクセス）

- `lib/provider/dio/poke_api_client.dart`
	- `Dio` を使った共通 API クライアント。
	- `https://pokeapi.co/api/v2` をベースに JSON を取得します。

- `lib/provider/package/pokemon_provider.dart`
	- ランダムなポケモン ID を生成してポケモン情報を取得。
	- 必要数（6匹）のポケモン取得と、日本語名取得（species API）を担当します。

- `lib/provider/search/type_provider.dart`
	- タイプ相性情報（`/type/{type}`）を取得。
	- 取得結果をキャッシュし、同じタイプの再取得を削減します。

### Model（データ構造）

- `lib/model/package/pokemon_model.dart`
	- ポケモン1匹分のデータモデル（ID, 日本語名, type1, 画像URL）。
	- APIレスポンスからモデルへ変換します。

- `lib/model/package/battle_outcome_model.dart`
	- 勝敗結果モデル（勝ち/負け/引き分け、双方ポケモン、倍率）を定義します。

- `lib/model/search/type_relation_model.dart`
	- タイプ相性データモデル。
	- `double_damage_to / half_damage_to / no_damage_to` を保持します。

## 実行方法

```bash
flutter pub get
flutter run
```

## 開発チェック

```bash
flutter analyze
flutter test
```
