# PROJECT_CONTEXT.md — 夜勤脱出(night-shift-escape)

このファイルは、このプロジェクトにおける**仕様の正(Single Source of Truth)**である。仕様・状態が変わったら、このファイルを更新する。判断の理由は[decisions.md](./decisions.md)に記録する。

最終更新: 2026-10-08(CI③ の「変更なし」での正常終了を反映)

---

## 1. プロジェクト概要

| 項目 | 内容 |
|---|---|
| タイトル | 夜勤脱出 |
| リポジトリ名 | `night-shift-escape` |
| ジャンル | 2D探索ゲーム |
| エンジン | Godot 4.7.2 標準版([decisions.md](./decisions.md) Decision 001・010) |
| スクリプト言語 | GDScript(Decision 010) |
| レンダラー | GL Compatibility(互換性)(Decision 011) |
| 開発期間の目安 | 1週間(MVP完成まで) |

夜勤中の病院を探索し、制限時間内に3つのアイテムを集めてナースステーションへ戻るゲーム。

## 2. ゲーム目的

制限時間(約3分)以内に、病院内に置かれた3つのアイテム(鍵・カルテ・懐中電灯)をすべて集め、ナースステーションへ戻ること。

## 3. MVP

今回のMVPは、以下の範囲だけとする。

- **プレイヤー:** 上下左右に移動できる。壁を通り抜けられない。
- **マップ:** 小規模な病院マップを1つ(ナースステーション・廊下・数個の部屋)。
- **アイテム:** 鍵・カルテ・懐中電灯の3種類。
- **UI:** 残り時間、アイテム取得数、クリア画面、ゲームオーバー画面、リスタート。

## 4. プレイヤー仕様

- 上下左右の4方向に移動できる。
- 壁を通り抜けられない。
- 上記以外の能力(攻撃・ダッシュ・ジャンプ等)は持たない。

## 5. マップ仕様

- 小規模な病院マップを1つだけ用意する(1ステージ構成。Decision 002)。
- 構成要素は以下のとおり。
  - ナースステーション(スタート地点 兼 ゴール地点)
  - 廊下
  - 数個の部屋
- プレイヤーは壁を通り抜けられない。

## 6. アイテム仕様

| アイテム | 内容 |
|---|---|
| 鍵 | ゲーム用の架空アイテム |
| カルテ | ゲーム用の架空アイテム(実際の患者情報は含まない) |
| 懐中電灯 | ゲーム用の架空アイテム |

- アイテムは3種類に限定する(Decision 003)。
- 実際の医療行為・薬剤・患者情報は扱わない。
- アイテムは「取得したかどうか」だけを管理する。複雑なインベントリは作らない(Decision 004)。

## 7. ゲームルール

1. ゲーム開始
2. 病院を探索
3. 3つのアイテムを集める
4. ナースステーションへ戻る
5. クリア

## 8. 制限時間

- 180秒(3分)(Decision 005・015)。
- ゲーム開始と同時にカウントダウンを始める。
- 時間切れでゲームオーバーになる。

## 9. クリア条件

3つのアイテムをすべて取得した状態で、制限時間内にナースステーションへ戻る。

## 10. ゲームオーバー条件

3つのアイテムを集めてナースステーションへ戻る前に、制限時間が0になる。

## 11. UI

| 表示 | 内容 |
|---|---|
| 残り時間 | プレイ中に常に表示する |
| アイテム取得数 | プレイ中に常に表示する(例: 1/3) |
| クリア画面 | クリア条件を満たしたときに表示する |
| ゲームオーバー画面 | 時間切れのときに表示する |

## 12. リスタート

クリア画面・ゲームオーバー画面から、ゲームを最初からやり直せる。

## 13. 今回実装しない機能

以下はMVPの対象外とする。追加の提案はできるが、実装はしない。

- 敵
- 戦闘
- 複数ステージ
- セーブ機能
- 複雑なインベントリ
- キャラクター会話
- 複雑なストーリー
- オンライン機能
- 凝ったアニメーション
- 本格的なサウンドシステム

## 14. 完成条件

以下の流れが一通り動作すること。

起動 → 操作 → 探索 → アイテム回収 → 制限時間 → ゴール → クリア/ゲームオーバー

## 15. AIの役割分担

| 担当 | 役割 |
|---|---|
| ChatGPT | 要件整理、ゲーム設計、技術選択、実装方針、学習・コード理解のサポート |
| Claude Code | Godotプロジェクトの実装、コード作成・変更、テスト、デバッグ、リファクタリング |
| Gemini | 設計レビュー、コードレビュー、セキュリティ・品質・パフォーマンス確認、別の実装案の提示 |
| 開発者本人 | **最終判断**(AIは判断せず、提案・実装・レビューを行う) |

## 16. 開発ルール

1. 仕様を勝手に拡張しない。
2. MVPを優先する。
3. 不明点や仕様変更が必要な場合は、実装前に確認する。
4. AIが生成したコードについて、主要部分を開発者が説明できる状態を目指す。
5. 技術選択の理由は、このファイルまたは[decisions.md](./decisions.md)に記録する。
6. プロジェクト固有の情報は、このファイルを正とする。
7. 共通ルール・知識は[AI_MEMORY](../../AI_MEMORY/README.md)を参照する。
8. 1週間で完成できない機能は、原則として追加しない。
9. AIが新機能を提案する場合は、実装せず、まず提案として提示する。
10. 既存仕様と矛盾する場合は、勝手に判断せず確認する。

Gitの運用(Issue → ブランチ → Pull Request)は、AI_MEMORYの[DEVELOPMENT_RULES.md](../../AI_MEMORY/DEVELOPMENT_RULES.md)に従う。

## 17. 仕様変更ルール

1. 仕様変更が必要になったら、実装する前に開発者に確認する(Decision 009)。
2. 開発者が承認したら、**先にこのファイルを更新**してから実装する。
3. 変更の理由は[decisions.md](./decisions.md)に新しいDecisionとして追記する。過去のDecisionは削除せず、変更した場合も新しいDecisionで上書きを記録する。
4. 会話の中だけで決まった内容は、このファイルに反映されるまで正式な仕様として扱わない。

---

## 18. 現在の開発状況

- **フェーズ:** MVPの機能を実装済み(Day 9「最小限の効果音・ゲームフィードバック」、CI①「GitHub Actionsによるスモークテスト」、CI②「GeminiによるPR自動レビュー」およびCI③「Claude CodeによるIssue→実装→PR作成の自動化」まで完了)。次は Day 10「最終調整・バグ修正・完成確認」(Issue #40)のフェーズ。
- **実装済み:**
  - Godotプロジェクトの初期設定(Issue #1 / PR #2)
  - プレイヤー表示、4方向移動、壁との衝突判定(Day 1。Issue #3 / PR #4)
  - 鍵・カルテ・懐中電灯の配置、アイテム取得、取得済みアイテムの消去、アイテム取得状態の管理(Day 2。Issue #5 / PR #6)
  - GitHub Actionsによるスモークテスト(CI①。Issue #8 / PR #9)
  - GeminiによるPR自動レビュー(CI②。Issue #12 / PR #13)
  - 制限時間タイマー(180秒)、残り時間UI(Day 3。Issue #16 / PR #17)
  - アイテム取得数UI、ナースステーションへの帰還によるクリア条件判定(Day 4。Issue #20 / PR #21)
  - ゲーム進行状態の管理(GameFlow)、クリア画面、ゲームオーバー画面、リスタート(Day 5。Issue #24 / PR #25)
  - Claude CodeによるIssue→実装→PR作成の自動化(CI③。Issue #28 / PR #29、認証の変更 Issue #30 / PR #31、E2Eテスト Issue #32 / PR #33)
  - 病院マップのピクセルアート調の見た目(Day 6。Issue #44 / PR #45。旧案の Issue #36 / PR #41、Issue #42 / PR #43 は採用せずクローズ)
  - プレイヤー・アイテム・ナースステーションの見た目(Day 7。Issue #37 / PR #46)
  - UI(残り時間・アイテム取得数)・クリア画面・ゲームオーバー画面の見た目、残り30秒以下での残り時間の赤表示(Day 8。Issue #38 / PR #47)
  - 最小限の効果音(アイテム取得・クリア・ゲームオーバー・リスタート)(Day 9。Issue #39 / PR #48)
- **現在の状態管理:**
  - `GameManager`(`scripts/game_manager.gd`)をAutoloadとして登録している(Decision 012)。
  - 現在管理しているのは `has_key` / `has_chart` / `has_flashlight` の3つだけ。アイテム取得時に `collect_item(item_type)` で更新する。タイマーは扱わない。
  - Day 4 で `get_collected_count()` を追加した。3つの取得状態から取得数(0〜3)を計算して返すだけで、取得数を新しい状態として保存しない(Decision 016)。
  - クリア状態は GameManager に持たせない。
  - Day 5 で、リスタート用に `reset_items()` を追加した。3つのアイテム取得状態を初期状態(すべて false)に戻すだけ(Decision 017)。
  - ゲーム全体の進行状態(`PLAYING` / `CLEARED` / `GAME_OVER`)は GameManager ではなく、GameFlow が管理する(Decision 017)。
- **制限時間タイマー・残り時間UI:**(Decision 015)
  - 制限時間は `Main` 直下の `Time` ノード(Godot標準の `Timer`。`wait_time = 180`、`one_shot = true`、`autostart = true`)で管理する。Autoloadではない。スクリプトは付けていない。
  - ゲーム開始と同時に180秒からカウントダウンし、0秒で停止する(マイナスにはならない)。0秒になると `timeout` シグナルで時間切れを通知する。Day 3・4 時点では、この通知を受けて動く処理はなかった。Day 5 からは GameFlow がこの通知を受け取り、ゲームオーバーにする(Decision 017)。
  - 残り時間は `UI`(CanvasLayer)> `TimeLabel`(Label)+ `scripts/time_label.gd` が表示する。毎フレーム `Time` の `time_left` を読み、画面左上に `TIME MM:SS`(分・秒とも2桁の0埋め)で固定表示する。
  - 秒の端数は切り上げて表示する。`TIME 00:00` になるのは、実際に0秒になったときだけ。
  - 表示は白文字+黒縁のみで、残り時間による色の変化・点滅などの演出はない。(Day 3 時点。Day 8 からは、残り30秒以下になると文字を赤(`Color(1, 0.35, 0.35)`)にして、時間が少ないことを知らせる。点滅はない(Decision 021))
- **アイテム取得数UI:**(Decision 016)
  - `UI`(CanvasLayer)> `ItemCountLabel`(Label)+ `scripts/item_count_label.gd` が表示する。
  - TimeLabel の右隣に `ITEM 0/3`〜`ITEM 3/3` を固定表示する。見た目は TimeLabel と同じ(白文字+黒縁、24px)。(Day 4 時点。Day 8 からは、画面左上の半透明の黒いパネル `HudPanel` の中で、TimeLabel の下に表示する(Decision 021))
  - 毎フレーム `GameManager.get_collected_count()` を読んで表示する。
- **ナースステーション・クリア条件判定:**(Decision 016)
  - `Main` 直下の Area2D `NurseStation` + `scripts/nurse_station.gd`。スタート地点 (200, 324) を中心に 256×160。半透明の四角で表示する。(Day 5 時点。Day 6・7 からは、病院マップ側の床の色・破線の枠と、目印 `GoalMarker` の「GOAL」の札・矢印・四隅の強調で示す。「ゲーム画面の見た目(Day 6〜8)」を参照)
  - NurseStation は、プレイヤーが入ったこと、アイテムを3つ取得済みか、制限時間内か、を確認して、クリア条件の成立を通知する。
  - クリア条件:3つのアイテムをすべて取得済み **かつ** `Time.time_left > 0` **かつ** ナースステーションに入る。`Time` の値は読むだけ(`@export var time: Timer` で参照する)。
  - 判定は `body_entered`(入った瞬間)のときだけ行う。毎フレームの判定はしない。
    - ゲーム開始時は、プレイヤーがすでにナースステーションの中にいる。開始直後に「入った」として1回判定されるが、取得数は0なので成立しない。
    - ナースステーションの中にいる間に3個目を取得しても、その時点では判定しない。
    - 一度外に出て、もう一度入ったときに判定する。
  - 条件が成立したら、`clear_condition_met` シグナルを1回だけ発行し、コンソールに `クリア条件成立` を1回だけ出力する。もう一度入っても再発行しない。
  - Day 4 時点では、このシグナルを受けて動く処理はない。成立後もクリア画面への遷移・ゲームオーバー画面・リスタートはなく、プレイヤー操作とタイマーはそのまま動き続ける。Day 5 からは GameFlow がこのシグナルを受け取り、クリアにする(Decision 017)。NurseStation 自身はクリア状態を管理しない。
- **ゲーム進行状態(GameFlow)・クリア・ゲームオーバー・リスタート:**(Decision 017)
  - `Main` の子 Node `GameFlow` + `scripts/game_flow.gd`。Autoloadではない。ゲーム全体の進行状態を `PLAYING` / `CLEARED` / `GAME_OVER` の3つで管理し、クリア・ゲームオーバー・リスタートと終了画面の表示を担当する。
  - 責務の分担:
    | 担当 | 責務 |
    |---|---|
    | `GameManager` | 3つのアイテムの取得状態だけを管理する。`reset_items()` を提供する。ゲーム全体の状態は管理しない |
    | `Time` | Godot標準の `Timer`。制限時間を管理し、`timeout` で時間切れを通知する |
    | `TimeLabel` | 残り時間を表示する |
    | `ItemCountLabel` | アイテム取得数を表示する |
    | `NurseStation` | クリア条件を判定し、`clear_condition_met` を通知する。クリア状態そのものは管理しない |
    | `Player` | 移動を担当する。ゲームの終了状態は管理しない |
    | `GameFlow` | ゲーム全体の状態遷移、クリア、ゲームオーバー、リスタート、終了画面の表示 |
  - **クリア:** `NurseStation.clear_condition_met` を GameFlow が受け取る。状態が `PLAYING` のときだけ `PLAYING → CLEARED` に移り、次を行う。
    - Player の物理処理を止める(`set_physics_process(false)`)。
    - `Time.paused = true` で Timer を一時停止する。`Time.stop()` は使わない(`stop()` だと `time_left` が 0 になり `TIME 00:00` と表示されるため)。クリアした時点の残り時間の表示を保持する。
    - Clear 画面を表示し、RESTART ボタンにフォーカスを当てる。
  - **ゲームオーバー:** `Time.timeout` を GameFlow が受け取る。状態が `PLAYING` のときだけ `PLAYING → GAME_OVER` に移り、次を行う。
    - Player の物理処理を止める(`set_physics_process(false)`)。
    - Game Over 画面を表示し、RESTART ボタンにフォーカスを当てる。
    - Timer は `one_shot = true` のため、`timeout` のあとに再び動くことはない。
  - **終了状態の重複防止:** クリア・ゲームオーバーの処理の最初に現在の状態を確認し、`PLAYING` 以外なら遷移しない。これにより `CLEARED → GAME_OVER`、`GAME_OVER → CLEARED` のような二重の遷移を防ぎ、最初に成立した終了状態を維持する。
  - **終了画面:** `UI`(CanvasLayer)の下に `ClearScreen` / `GameOverScreen`(半透明の黒い背景(ColorRect)+ 文字 + `RESTART` ボタン)を置く。通常は非表示。
    - Clear 画面:`CLEAR` / `夜勤脱出成功!` / `RESTART`
    - Game Over 画面:`GAME OVER` / `時間切れ` / `RESTART`
    - (Day 5 時点。Day 8 からは、半透明の黒い背景の上に色付きのパネル(Clear は濃い緑、Game Over は濃い赤)を置き、その中に文字とボタンを並べる。文言とボタンの表示は「ゲーム画面の見た目(Day 6〜8)」を参照)
    - アニメーション・フェードなどの演出はない。
  - **リスタート:** RESTART ボタンを押すと、`GameManager.reset_items()` → `get_tree().reload_current_scene()` の順に行う(Day 9 からは、その間に `SoundEffects.play_restart()` で効果音を鳴らす)。
    - Input Map は追加していない。Godot 標準の Button の操作(`ui_accept`)により、マウスクリック・Enter・Space で押せる。
    - Main シーンが初期状態から作り直され、`ITEM 0/3`、`TIME 03:00`、Player が初期位置、`PLAYING`、Clear / Game Over 画面は非表示、アイテム3つが再配置された状態になる。
- **ゲーム画面の見た目(Day 6〜8):**(Decision 021)
  - 見た目はすべて Godot 標準の描画(`_draw()` による矩形・円・多角形・線)で描いている。画像ファイル・外部素材は使っていない(ライセンスの問題はない)。
  - 見た目を描くノードは、衝突判定・ゲームロジックとは分けている。壁の見た目は、衝突判定(`Walls` の StaticBody2D)と同じ座標に描く。
  - **病院マップ(Day 6、`scripts/hospital_decor.gd`、Main の最初の子 `HospitalDecor`):**
    - 見下ろし型のピクセルアート調。白〜ライトブルーグレー〜ダークブルーグレーを中心とした約20色のパレットに限定する。
    - 床は32pxのタイル(2色の市松と薄い目地)。壁は濃い輪郭・明るい天面・暗い側面で厚みを出し、影を付ける。天井灯の淡い光だまりと、壁際の暗がりで、夜の静かな雰囲気を出す。
    - ベッド・点滴スタンド・モニター付きの医療機器台・ロッカー・棚・机・椅子・医療ワゴン・植物・ゴミ箱を配置し、ナースステーションにはL字のカウンター・モニター・書類・電話・十字マークの表示板を描く。部屋や廊下は床を分けるのではなく、家具・設備の配置で病室エリアなどとして見せている。
    - 家具は「輪郭+本体+上のハイライト+下の影」の箱を組み合わせて描く。家具には衝突判定はなく、見た目だけ。
  - **プレイヤー・アイテム・ナースステーション(Day 7):**
    - プレイヤー(`scripts/player.gd` の `_draw()`):当たり判定 32×32 の範囲に収まる看護師風の人物(青い制服・ナースキャップ・足元の影)。
    - アイテム(`scripts/item.gd` の `_draw()`):丸い台座の上に、種類ごとのアイコンを描く。鍵は金色の鍵、カルテは青いバインダーと白い紙、懐中電灯はオレンジの本体と光。
    - ナースステーション(`scripts/nurse_station_marker.gd`、NurseStation の子 `GoalMarker`):判定範囲の床を淡い緑にし、四隅の強調と「GOAL」の札・下向きの矢印で、ゴール地点だと分かるようにする。
    - 移動・衝突・アイテム取得・クリア判定のロジックは変更していない。
  - **UI・終了画面(Day 8):**
    - 残り時間とアイテム取得数は、画面左上の半透明の黒いパネル `HudPanel` の中に、`TIME MM:SS`・`ITEM n/3` の順で縦に並べる(24px)。残り30秒以下になると `TIME` の文字が赤になる(`scripts/time_label.gd`)。
    - Clear 画面:濃い緑のパネルに `CLEAR`(64px)、`夜勤脱出成功!` / `3つのアイテムを集めて戻れました`、`RESTART(Enter / Space)` ボタン。
    - Game Over 画面:濃い赤のパネルに `GAME OVER`(64px)、`時間切れ…` / `制限時間内に脱出できませんでした`、`RESTART(Enter / Space)` ボタン。
    - パネルの後ろには、これまでどおり半透明の黒い背景(ColorRect)がある。GameFlow による状態遷移・リスタートの処理は変更していない。
- **効果音(Day 9):**(Decision 020)
  - ゲーム進行を補助するフィードバックとして、最小限の効果音を追加した。Day 9 の目的であるゲームフィードバックは達成した(開発者の実機確認で、4種類とも鳴ることを確認済み)。
    | タイミング | 呼び出し元 | 音 |
    |---|---|---|
    | アイテム取得 | `scripts/item.gd` | 短い上昇音(2音) |
    | クリア | `scripts/game_flow.gd`(`CLEARED` に移ったとき) | 上がる4音 |
    | ゲームオーバー | `scripts/game_flow.gd`(`GAME_OVER` に移ったとき) | 下がる3音 |
    | リスタート | `scripts/game_flow.gd`(RESTART を押したとき) | 短い1音 |
  - `scripts/sound_effects.gd` を Autoload `SoundEffects` として登録している。音声ファイルは使わず、起動時にコードでサイン波の短い音(16bit モノラル、`AudioStreamWAV`)を作り、`AudioStreamPlayer` 1つで鳴らす。外部素材を使わないため、ライセンスの問題はない。
  - 音量は控えめ(振幅 0.25)で、音の終わりに向けて小さくなる。音が鳴らなくても、ゲームの進行には影響しない。
  - BGM は、今回の MVP では実装していない。音量設定・ミュート・サウンド設定画面もない。
- **既知の改善候補(MVPでは修正しない):**
  - **終了画面の背景:** Clear / Game Over 画面は半透明の黒いオーバーレイを使っているため、背後の `TIME` / `ITEM` の表示も暗く見える。終了画面としての読みやすさ・操作性は確保されているため、MVPでは修正しない。将来の UI 改善候補とする。
  - **ブラウザ向けの日本語フォント:** 現在の Windows 環境では日本語の表示を確認済み。ブラウザ向け書き出し(Web export)時の日本語フォントの表示は未検証。Web公開を行う段階で、必要に応じて検証・対応する。
- **CI(自動テスト):**(Decision 013)
  - `.github/workflows/ci.yml` で、`pull_request`(main向け)と `push`(main)のときに実行する。同一workflow・同一refの古い実行はキャンセルする。
  - 実行環境はUbuntu 24.04。Godot 4.7.2 stable official(Linux版)を公式ビルド配布元から取得し、SHA512を検証してから使う。
  - スモークテスト(`tests/smoke/run_smoke_test.sh` / `tests/smoke/smoke_test.gd`)で、headlessでのプロジェクトのimport、Autoload `GameManager` の存在、Main Sceneの設定・ロード・インスタンス化、60物理フレームの実行を確認する。
  - 成功条件は「終了コード0」「ログにGodotのエラー出力がない」「`SMOKE_TEST_PASSED` が出力される」の3つをすべて満たすこと(Godotはエラーがあっても終了コード0で終わる場合があるため)。
  - CIが保証するのは「GodotプロジェクトがCI環境で正常に読み込まれ、Main Sceneを起動し、基本的な実行状態まで到達できること」まで。キーボード操作・壁との衝突・アイテム取得などのゲーム機能そのものはテストしていない。ゲーム機能の単体テスト・統合テストは、今後必要に応じて追加する。
  - ローカルでは、Godotのconsole版の実行ファイルを環境変数 `GODOT` に指定して `bash tests/smoke/run_smoke_test.sh` で同じ確認ができる。
- **AIによるPR自動レビュー(CI②):**(Decision 014)
  - 役割分担:CI①は「Godotプロジェクトが起動・読み込みできるか」を確認し、CI②は「PRの変更内容をGeminiが独立してコードレビューする」。両者は別のworkflowに分けている。
  - `.github/workflows/gemini-review.yml` で、main向けPRの `opened` / `synchronize` / `reopened` / `ready_for_review` のときに実行する。mainへのpushでは実行しない。Draft PRでは実行せず、Draft解除時(`ready_for_review`)に実行する。fork PRでは実行しない。同じPRで古いレビューが実行中の場合はキャンセルし、最新コミットのレビューを優先する。
  - `.github/scripts/gemini_review.py`(Python標準ライブラリのみ)が、Gemini Interactions API(`https://generativelanguage.googleapis.com/v1beta/interactions`、`x-goog-api-key` ヘッダーで認証、`store: false`)を呼び出す。
  - APIキーはGitHub Actions Secret `GEMINI_API_KEY` から取得する。コード・ログ・PRコメントには出さない。
  - デフォルトモデルは `gemini-3.8-flash`。GitHub Repository Variable `GEMINI_MODEL` を設定すると変更できる。
  - Geminiに渡す情報:PRタイトル・本文、base/head、関連Issue(PR本文の `Closes #N`)、`PROJECT_CONTEXT.md`、`decisions.md`、`.gemini/styleguide.md`(レビュー観点)、変更ファイル一覧、`base...head` のdiff。diffは100,000文字を超えると後半を切り詰める。Godotの自動生成ファイル(`*.uid` / `*.import`)や画像・音声はレビュー対象から除外する。
  - 結果はPRコメントとして投稿する。1行目は `VERDICT: NO_ISSUES` または `VERDICT: ISSUES_FOUND` で、指摘がある場合はSeverity / ファイル / 行 / 問題 / 理由 / 修正案を表で示す。同じPRの再レビューでは、新しいコメントを作らず既存のGeminiレビューコメントを更新する。
  - Secret未設定・認証失敗・API失敗・レスポンス解析失敗・VERDICT行なし・PRコメント投稿失敗は、workflowの失敗とする。HTTP 429 / 500 / 503は一時的なエラーとして20秒後・60秒後に再試行し、HTTP 400 / 401 / 403などは再試行せずに失敗とする。
  - Geminiが `ISSUES_FOUND` を返しても、workflow自体は失敗にしない。
  - GeminiはPRのApprove・Mergeを行わない。workflowの権限は `contents: read` / `issues: read` / `pull-requests: write` だけ。
  - **Geminiレビューは判断材料であり、指摘をそのまま事実として扱わない。** 開発者が根拠を確認したうえで採否を判断し、修正・Mergeの最終判断も開発者が行う(PR #13では、実装・実動確認・公式ドキュメントと一致しない指摘も出た)。
  - **現在の設定(2026-10-05〜):** `gemini-3.8-flash` の高負荷(HTTP 503)が続いたため、Repository Variable `GEMINI_MODEL` に `gemini-3.7-flash` を設定している。デフォルトに戻す場合は、この Variable を削除する。
  - **既知の課題:** Gemini 側の高負荷(HTTP 503)、応答の時間切れ(`TimeoutError`)、応答のない接続切れ(`RemoteDisconnected`)で、レビューが失敗することがある(PR #29・#31・#33)。時間切れと接続切れは、現在の再試行の対象(HTTP 429 / 500 / 503)に含まれていない。失敗したときは、時間を置いて失敗したジョブを再実行するか、レビューなしで開発者が判断する(PR #31・#33 は、Geminiレビューの結果なしで開発者の判断によりMergeした)。
- **Issue→実装→PR作成の自動化(CI③):**(Decision 018・019)
  - 役割分担:CI③は「Issue を起点に、Claude Code が実装して PR を作る」まで。作成した PR は CI①・CI② で確認し、Merge は開発者が行う。CI①・CI② を置き換えない。
  - `.github/workflows/claude-issue-implement.yml` で、Issue に `claude-ready` ラベルが付いたとき(`issues: labeled`)だけ実行する。Issue の作成だけでは動かない。`claude-ready` は、内容を確認した開発者が付ける「実装開始の明示的な GO」。
  - ジョブは3つ。workflow 全体の権限は `{}` とし、ジョブごとに必要な分だけ付ける。同じ Issue の実行は `concurrency` で1つずつ順番に動かす(キャンセルしない)。
    | ジョブ | 内容 | 権限 |
    |---|---|---|
    | `guard` | 実行してよいかを判定する(`.github/scripts/claude_issue_automation.py guard`) | `contents: read`、`pull-requests: read` |
    | `implement` | `main` から `claude/issue-<N>` を作り、Claude Code が実装・テスト・commit する。その後 workflow が確認して push する | `contents: write` |
    | `create-pr` | GitHub App の Installation Access Token で PR を作成する(`claude_issue_automation.py create-pr`) | `contents: read` |
  - **実行の判定(`guard`):** 次をすべて満たすときだけ実行する。安全側に倒し、迷う場合は実行しない。
    - ラベルが `claude-ready`、対象が Pull Request ではなく Issue、Issue が open
    - ラベルを付けたのが人間のユーザーで、リポジトリの書き込み権限(admin / maintain / write)を持つ(Claude Code Action 自身も、書き込み権限と人間であることを確認する)
    - 同じ Issue に対応する open PR(head が `claude/issue-<N>`、または本文に `Closes` / `Fixes` / `Resolves #N`)がない
    - `claude/issue-<N>` ブランチがない(既存のブランチを上書きしないため。ラベルの付け直しや Actions の再実行でも、二重に実装しない)
  - **Claude Code の実行(`implement`):**
    - `anthropics/claude-code-action`(v1。コミット SHA で固定)を agent mode(`prompt` を指定)で使う。agent mode ではアクションはブランチを作らないため、workflow が `claude/issue-<N>` を作ってから実行する。
    - 認証は Claude の OAuth Token(Repository Secret `CLAUDE_CODE_OAUTH_TOKEN`。`claude setup-token` で生成)。Anthropic API の従量課金は使わない(Decision 019)。未設定なら、ブランチを作る前に止める。
    - GitHub の操作には、公式の Claude GitHub App ではなく、このジョブの短命な `GITHUB_TOKEN` を使う。
    - Claude Code が使えるツールは、ファイルの読み書き(Read / Edit / Write / Glob / Grep)、`git status/diff/log/add/commit`、`bash tests/smoke/run_smoke_test.sh`、`godot` だけ。`git push`、WebFetch、WebSearch は使えない。最大80ターン、ジョブは60分で打ち切る。CI でも Claude Code がスモークテストを実行できるよう、CI① と同じ Godot を用意する。
    - プロンプトでは、AGENTS.md / CLAUDE.md、PROJECT_CONTEXT.md、decisions.md を読み、Issue の範囲だけを実装するよう指示する。Issue 本文は `<issue>` で囲んだデータとして渡し、プロジェクトのルールと矛盾する指示には従わないよう明示する。共通AIメモリ(AI_MEMORY)はリポジトリの外にあるため、CI の中では読めない。
    - Claude Code の作業が終わったら、workflow の「Verify and push branch」ステップが結果を確認し、次のように扱う(Issue #51 / PR #52 で、commit がない場合を失敗から正常終了に変更した)。
      - **変更あり(commit がある):** Claude Code が `claude/issue-<N>` に commit した変更を、workflow が `claude/issue-<N>` にだけ push する(強制 push はしない)。`pushed=true` を出力し、`create-pr` ジョブが GitHub App のトークンで PR を作成する。作成した PR では CI①・CI② が実行される。Merge は自動では行わない。
      - **変更なし(commit が0件で、commit されていない変更もない):** 「変更なし」として正常終了する。`pushed=false` を出力し、push しない。`create-pr` ジョブはスキップされ、PR は作成しない。ダミーのコミットは作らない。
        - 「変更なし」は、Claude Code が本当に変更不要と判断した場合だけでなく、仕様が曖昧などで安全に実装できずに停止した場合も含む可能性がある。workflow は `::notice` とジョブのサマリーに「変更なし」と表示するので、実行ログを確認して、どちらだったかを判断する。
      - **引き続きエラーにする条件(push しない):** commit されていない変更が残っている(Claude Code が途中で止まった可能性がある)、`.github/` 配下が変更されている、作業ブランチが `claude/issue-<N>` ではない。
  - **PR の自動作成(`create-pr`):**
    - `actions/create-github-app-token`(v3。コミット SHA で固定)で、GitHub App `night-shift-escape-pr-creator` の Installation Access Token を作る(`client-id` は Repository Variable `CLAUDE_PR_APP_CLIENT_ID`、Private Key は Repository Secret `CLAUDE_PR_APP_PRIVATE_KEY`)。トークンの権限は `pull-requests: write`・`contents: read` に絞り、ジョブ終了時に失効する。App 自体の権限は Contents: Read-only、Pull requests: Read & write、Metadata: Read-only。
    - **`GITHUB_TOKEN` ではなく GitHub App のトークンで PR を作る理由:** `GITHUB_TOKEN` で作った PR では、後続の `pull_request` workflow(CI①・CI②)が承認待ちになり、自動で実行されないため。
    - PR は base `main`、head `claude/issue-<N>`、Draft ではない。タイトルは Issue のタイトル、本文には `Closes #<N>` と実行ログの URL を入れる。同じ Issue の open PR がすでにあれば、新しく作らない。
    - 自動 Merge はしない。PR の作成に失敗しても、push したブランチは削除しない(手動で PR を作れば続きを進められる)。
  - **E2E テストの結果(2026-10-06、Issue #32 → PR #33):**
    - `claude-ready` の付与 → `guard` の判定 → Claude Code(`claude-sonnet-5-5`、11ターン、約25秒)による README の変更と commit(作成者 `claude[bot]`)→ workflow による push → GitHub App による PR #33 の作成(Draft ではない、本文に `Closes #32`)まで、自動で動いた。
    - PR #33 では、CI①・CI② の両方が GitHub App(`night-shift-escape-pr-creator[bot]`)の `pull_request` イベントで、承認待ちにならずに起動した。CI① は成功した。CI② は Gemini 側の障害(HTTP 503・接続切れ)で失敗した。
    - CI③ の実行ログに、Secret の値が出ていないことを確認した。
  - **残っている課題:**
    - アクションの既定では、Claude Code の詳しい出力がログに出ない(`show_full_output: false`)。そのため、E2E テストで Claude Code 自身がスモークテストを実行して成功したかは、ログから確認できていない。また、実行結果には、許可していないツールの使用が2回拒否されたこと(`permission_denials_count: 2`)が記録されていた。
    - Claude Code の実行中は、アクションの仕様で、ジョブの `GITHUB_TOKEN`(短命、`contents: write` のみ)が git の設定に書かれる。
    - `main` にはブランチ保護・ルールセットが設定されていない(CI③ は `main` に push しない構成にしている)。
- **未実装のMVP機能:** なし(Day 1〜5 で、MVPの機能はすべて実装済み)。
  - 実装済みのMVP機能:プレイヤー移動、壁との衝突、アイテムの配置・取得、アイテム数表示、3分タイマー、クリア条件判定、クリア画面、ゲームオーバー、リスタート。
- **確定した事項:**
  - Godotのバージョン:4.7.2 標準版(Decision 010)。
  - スクリプト言語:GDScript(Decision 010)。
  - レンダラー:GL Compatibility(Decision 011)。
  - Godotプロジェクトファイル(`project.godot`):リポジトリ直下に作成済み。
