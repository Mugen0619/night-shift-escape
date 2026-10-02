# Geminiレビュー観点 — 夜勤脱出(night-shift-escape)

GitHub ActionsのGeminiによるPR自動レビュー(`.github/workflows/gemini-review.yml`)が参照する、レビュー観点のまとめ。
仕様そのものは `PROJECT_CONTEXT.md`(仕様の正)、判断の理由は `decisions.md` を見ること。このファイルには、それらと重複しない「何を確認するか」だけを書く。

## 正確性
- 明らかなバグ、ロジックの誤り、想定外の動作がないか。
- エラー処理の不足がないか。想定外の値は `push_error` 等で気付けるようになっているか(例: `GameManager.collect_item` の未知のアイテム種類)。

## Godot 4.7.2 / GDScript
- Godot 3系の書き方が混ざっていないか(`yield` → `await`、`KinematicBody2D` → `CharacterBody2D`、`connect("signal", self, "method")` → `signal.connect(callable)`、`export` → `@export` 等)。
- 型ヒントが付いているか(既存コードは `var x: int`、`func f() -> void` の形で統一している)。
- 移動・衝突の処理を `_physics_process` で行っているか。`move_and_slide()` に `delta` を掛けた速度を渡していないか。
- `_ready` でのノード参照(`$Node`)が、シーン(`.tscn`)のノード名・構成と一致しているか。
- signalの接続が二重になっていないか。`queue_free()` した後のノードを使っていないか。
- 衝突レイヤー・マスク、`Area2D` と `PhysicsBody2D` の使い分けが意図どおりか。
- Autoload(`GameManager`)の責務が、Decision 012の範囲を超えて増えすぎていないか。
- レンダラーはGL Compatibility(Decision 011)。Forward+専用の機能を使っていないか。

## プロジェクト設計・スコープ
- `PROJECT_CONTEXT.md` の仕様、`decisions.md` の判断と矛盾していないか。
- 「13. 今回実装しない機能」(敵、戦闘、複数ステージ、セーブ、複雑なインベントリ等)が入っていないか。
- 関連Issueの範囲を超える変更(ついでのリファクタリング、無関係なファイルの変更)がないか。
- MVPに対して不要な複雑化・過剰な汎用化がないか。
- 仕様が変わる変更なのに、`PROJECT_CONTEXT.md` / `decisions.md` が更新されていない場合は指摘する。
- 実在の医療行為・薬剤・患者情報を扱っていないか(アイテムは架空のもの)。

## セキュリティ / GitHub Actions
- APIキー等のSecretが、コード・ログ・PRコメントに出ていないか。`.env` 等をコミットしていないか。
- workflowの `permissions` が必要最小限か(不要な `contents: write` 等がないか)。
- `pull_request_target` など、fork PRのコードをSecret付きで実行する危険な構成になっていないか。
- PRタイトル・本文などの外部入力を、`run:` の中で `${{ }}` として直接展開していないか(環境変数経由で渡す)。
- 使用するActionがコミットSHAで固定されているか。

## テスト / CI
- 既存のスモークテスト(`.github/workflows/ci.yml` / `tests/smoke/`)を壊す変更になっていないか。
- Main Sceneやスクリプトの読み込み時にエラーが出る可能性がないか(スモークテストはエラーログでも失敗する)。
- Day 1(移動・壁衝突)・Day 2(アイテム取得)の既存機能への回帰リスクがないか。
- 変更内容に対して、確認方法(手動確認の手順やテスト)がPR本文に示されているか。
