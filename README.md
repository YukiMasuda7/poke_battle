# poke_battle

PokeAPI を使った「ポケモンのタイプ相性じゃんけん」アプリです。  
ランダムに選ばれたポケモンで、タイプ相性にもとづいて勝敗を判定します。

## アプリ概要

- 自分の手持ち: ランダム 3 匹
- 相手: ランダム 1 匹
- 勝負方法: タイプ相性（単一タイプ判定）
- 複数タイプのポケモン: `type1`（`slot: 1`）のみ使用
- 表示: ポケモン名・タイプ名は日本語表示（可能な範囲）

## 操作方法

1. **スタート画面**で `スタート` を押す
2. PokeAPI からポケモン 4 匹をランダム取得
3. **選択画面**で自分の 3 匹から 1 匹を選ぶ
4. **結果画面**で勝ち / 負け / 引き分けを表示
5. `もう一回` を押すと、新しい 4 匹で再スタート

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

- 自分の倍率 > 相手の倍率 → **勝ち**
- 自分の倍率 < 相手の倍率 → **負け**
- 同じ → **引き分け**

## 画面構成

- `start`: スタートボタン表示
- `select`: 相手情報 + 自分のポケモン選択
- `result`: 勝敗結果 + 倍率 + 再戦ボタン

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

## 補足

- 画像 URL がない、または読み込みに失敗した場合は代替アイコンを表示
- API 通信エラー時は画面にエラーメッセージと再試行ボタンを表示
