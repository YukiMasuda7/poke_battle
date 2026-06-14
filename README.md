# poke_battle

PokeAPI を使った「タイプ相性じゃんけん」Flutter アプリです。

## 仕様

1. スタートでランダムに4匹取得
2. 自分の3匹から1匹選択
3. 相手1匹とのタイプ相性で勝敗判定
4. もう一度で 1 に戻る

複数タイプを持つポケモンでも `type1`（`slot: 1`）のみを使用します。

## API

- `GET /pokemon/{id}`
- `GET /type/{type}`

ベースURL: `https://pokeapi.co/api/v2`

## フォルダ構成

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

## 実行

```bash
flutter pub get
flutter run
```

## テスト/解析

```bash
flutter analyze
flutter test
```
