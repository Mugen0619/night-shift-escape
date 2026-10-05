# decisions.md — 夜勤脱出(night-shift-escape)

このプロジェクト固有の、技術・設計上の重要な判断とその理由を記録する。現在の仕様そのものは[PROJECT_CONTEXT.md](./PROJECT_CONTEXT.md)を正とする。

## 運用ルール

- 新しい判断は、末尾に次の番号で追記する(Decision 010, 011, ...)。
- 過去のDecisionは削除・書き換えしない。判断を変えた場合は新しいDecisionを追加し、「変更前の判断」に元の番号を書く。古い方の「状態」は「置き換え済み(Decision NNN)」に更新してよい。
- Decision 001〜009は、2026-10-01の初期セットアップ時に、開発者の初期指示書と個人開発ロードマップをもとに記録した。指示書に理由が書かれていない項目は「記録なし」とし、推測で補っていない。

### テンプレート

```markdown
## Decision NNN: <判断のタイトル>
- **日付:** YYYY-MM-DD
- **状態:** 採用 / 置き換え済み(Decision NNN)
- **判断内容:**
- **判断理由:**
- **採用しなかった選択肢:**
- **判断に影響した条件:**
- **再検討条件:**
- **変更前の判断:**(判断を変えた場合のみ)
```

---

## Decision 001: Godotを使用する

- **日付:** 2026-10-01
- **状態:** 採用
- **判断内容:** ゲームエンジンにGodotを使用する。
- **判断理由:** 無料・軽量で、2Dゲームに向いているため(個人開発ロードマップでの選定理由)。
- **採用しなかった選択肢:** 記録なし(ロードマップでGodotを選定した際、比較した候補の記録はない)。
- **判断に影響した条件:**
  - 小規模な2Dゲームを短期間(1週間)で完成させる目標。
  - 費用をかけずに始めたいこと。
- **再検討条件:** Godotでは実現が困難な要件が出た場合。

## Decision 002: 1ステージ構成にする

- **日付:** 2026-10-01
- **状態:** 採用
- **判断内容:** マップは小規模な病院マップ1つだけとする。
- **判断理由:** MVPを1週間で完成させるため、範囲を最小限に絞る(開発ルール8「1週間で完成できない機能は原則として追加しない」)。
- **採用しなかった選択肢:** 複数ステージ(MVP対象外)。
- **判断に影響した条件:** 開発期間の目安が1週間であること。
- **再検討条件:** MVPが完成し、拡張を検討する段階になった場合。

## Decision 003: アイテムを3種類に限定する

- **日付:** 2026-10-01
- **状態:** 採用
- **判断内容:** 収集アイテムは鍵・カルテ・懐中電灯の3種類に限定する。いずれもゲーム用の架空アイテムとし、実際の医療行為・薬剤・患者情報は扱わない。
- **判断理由:**
  - MVPの範囲を小さく保つため。
  - 実在の医療情報を扱わないため。
- **採用しなかった選択肢:** 記録なし。
- **判断に影響した条件:**
  - 開発期間の目安が1週間であること。
  - 病院を舞台にするが、実際の医療・患者情報を扱わない方針であること。
- **再検討条件:** MVPの完成後、拡張を検討する段階になった場合。

## Decision 004: 複雑なインベントリを実装しない

- **日付:** 2026-10-01
- **状態:** 採用
- **判断内容:** アイテムは「取得したかどうか」と取得数(○/3)だけを管理し、一覧画面・並べ替え・使用操作などのインベントリ機能は作らない。
- **判断理由:** クリア条件の判定に必要なのは「3つすべて取得したか」だけであり、MVPに不要な機能を作らないため。
- **採用しなかった選択肢:** 複雑なインベントリ(MVP対象外)。
- **判断に影響した条件:**
  - アイテムが3種類と少ないこと。
  - 開発期間の目安が1週間であること。
- **再検討条件:** アイテムを「使う」仕様が追加される場合。

## Decision 005: 制限時間を約3分にする

- **日付:** 2026-10-01
- **状態:** 採用
- **判断内容:** 制限時間を約3分とし、時間切れでゲームオーバーにする。
- **判断理由:** 記録なし(初期指示書で約3分と指定。理由の記載はない)。
- **採用しなかった選択肢:** 記録なし。
- **判断に影響した条件:** 小規模マップ1つという構成。
- **再検討条件:** テストプレイで、短すぎる・長すぎると判断した場合。正確な秒数は実装・テストプレイ時に決め、このファイルに追記する。
- **追記(2026-10-03):** Day 3(Issue #16 / PR #17)の実装で、制限時間を **180秒(3分)** に確定した。タイマーの実装方法は Decision 015 を参照。

## Decision 006: AIを開発工程に利用する

- **日付:** 2026-10-01
- **状態:** 採用
- **判断内容:** ChatGPT・Claude Code・Geminiを役割分担して使い、最終判断は開発者本人が行う(役割の詳細は[PROJECT_CONTEXT.md](./PROJECT_CONTEXT.md) 15章)。
- **判断理由:**
  - 要件整理・実装・レビューをそれぞれ得意なAIに分担させるため。
  - AIが生成したコードを開発者が説明できる状態を目指し、学習にもつなげるため(開発ルール4)。
- **採用しなかった選択肢:** 記録なし。
- **判断に影響した条件:**
  - 開発者は開発未経験からの学習中であること。
  - 複数のAIを併用する開発体制をとっていること。
- **再検討条件:** 役割分担がうまく機能しない場合。

## Decision 007: Gitで変更履歴を管理する

- **日付:** 2026-10-01
- **状態:** 採用
- **判断内容:** Gitで変更履歴を管理し、GitHub(`night-shift-escape`)で公開する。作業はIssue → ブランチ → Pull Requestの流れで進める。
- **判断理由:**
  - 変更履歴を追跡できるようにするため。
  - AIが行った変更を確認し、必要なら元に戻せるようにするため。
- **採用しなかった選択肢:** 記録なし。
- **判断に影響した条件:** 全プロジェクト共通の開発ルール(AI_MEMORYの[DEVELOPMENT_RULES.md](../../AI_MEMORY/DEVELOPMENT_RULES.md))。
- **再検討条件:** なし。

## Decision 008: MVPの完成を機能追加より優先する

- **日付:** 2026-10-01
- **状態:** 採用
- **判断内容:** MVPに定めた機能が一通り動作するまで、MVP外の機能は追加しない。AIが新機能を提案しても、実装せず提案にとどめる。
- **判断理由:**
  - 1週間で完成させるため(開発ルール2・8・9)。
  - 個人開発ロードマップで、まず「企画→完成→公開」のサイクルに慣れることを目的にしているため。
- **採用しなかった選択肢:** MVP開発と並行した機能追加。
- **判断に影響した条件:** 開発期間の目安が1週間であること。
- **再検討条件:** MVPが完成した後。

## Decision 009: 仕様変更は事前に確認する

- **日付:** 2026-10-01
- **状態:** 採用
- **判断内容:** 仕様変更が必要な場合や既存の仕様と矛盾する場合は、実装前に開発者が確認・承認し、[PROJECT_CONTEXT.md](./PROJECT_CONTEXT.md)を先に更新する。
- **判断理由:**
  - AIが仕様を勝手に拡張・変更するのを防ぐため(開発ルール1・3・10)。
  - 仕様の正をPROJECT_CONTEXT.mdの1か所に保つため。
- **採用しなかった選択肢:** AIの判断で仕様を変更すること。
- **判断に影響した条件:** 複数のAIで開発するため、AIごとに認識がズレる可能性があること。
- **再検討条件:** なし。

## Decision 010: Godot 4.7.2 標準版＋GDScriptを採用する

- **日付:** 2026-10-01
- **状態:** 採用
- **判断内容:** Godot 4.7.2 標準版(4.7.2.stable.official.ed1daf0bf)を使用し、スクリプト言語にGDScriptを採用する。
- **判断理由:**
  - Godotで一般的に利用されるスクリプト言語であり、情報量が多い。
  - Godotとの統合が良い。
  - 今回の小規模2Dゲームには十分である。
  - 追加の導入(.NET SDK等)を必要としない。
  - ブラウザ向けの書き出しが可能である。
- **採用しなかった選択肢:** Godot .NET版 / C#。
- **判断に影響した条件:**
  - 開発期間の目安が1週間であること。
  - MVPの規模が小さいこと。
- **再検討条件:** GDScriptでは実現が困難な要件が出た場合。

## Decision 011: GL Compatibility(互換性)レンダラーを採用する

- **日付:** 2026-10-01
- **状態:** 採用
- **判断内容:** Godotのレンダラーに GL Compatibility(互換性)を採用する(`project.godot` の `renderer/rendering_method="gl_compatibility"`)。
- **判断理由:**
  - 今回は小規模な2Dゲームであり、Compatibilityで十分である。
  - ブラウザ向け書き出しの選択肢を確保できる。
  - 今回の1週間という開発期間に対して必要十分な構成である。
- **採用しなかった選択肢:** Forward+(デスクトップ向けで、ブラウザ向け書き出しに対応していない)。
- **判断に影響した条件:**
  - 開発期間の目安が1週間であること。
  - 2Dのみで、高度な3Dグラフィックスを必要としないこと。
- **再検討条件:** Compatibilityでは実現できない描画表現が必要になった場合。

## Decision 012: GameManagerをAutoloadとして採用する

- **日付:** 2026-10-02
- **状態:** 採用
- **判断内容:**
  - Day 2で、アイテム取得状態を管理するために `GameManager`(`scripts/game_manager.gd`)を導入し、Autoloadとして登録する。
  - 現時点で管理するのは `has_key` / `has_chart` / `has_flashlight` の3つの取得状態だけとする。
  - アイテム取得時は `collect_item(item_type)` を通して取得状態を更新する。
  - GameManagerは現在、タイマー・UI・クリア判定・ゲームオーバー・リスタート・セーブなどを管理しない。
- **判断理由:**
  - アイテム取得状態をMain Sceneから分離し、ゲーム状態として独立して管理するため。
  - 今後、UIやクリア条件などが追加された際に、各機能が取得状態を参照しやすくするため。
  - Day 2では必要最小限の状態だけを管理し、過剰なゲームマネージャー化を避けるため。
- **採用しなかった選択肢:**
  - Main Sceneだけでアイテム取得状態を管理する方法。
  - 複雑な状態管理システムを導入する方法。
- **判断に影響した条件:**
  - Day 2では3種類のアイテム取得状態だけが必要であること。
  - 今後、タイマー・UI・クリア判定などの機能追加を予定していること。
  - MVPを小さく保ち、過剰設計を避けること。
- **再検討条件:**
  - GameManagerの責務が増えすぎた場合。
  - 現在の構成では管理しにくい状態が発生した場合。
  - MVP完成後にゲーム構造を拡張する場合。

## Decision 013: GitHub Actionsによるスモークテストを導入する

- **日付:** 2026-10-02
- **状態:** 採用
- **判断内容:**
  - CI①(Issue #8 / PR #9)で、GitHub Actions(`.github/workflows/ci.yml`)によるスモークテストを導入する。
  - 実行タイミングは `pull_request`(main向け)と `push`(main)とする。同一workflow・同一refの古い実行はキャンセルする(`concurrency`)。
  - 実行環境はUbuntu 24.04(`ubuntu-24.04`)のrunnerとする。
  - Godotは4.7.2 stable official(Linux版)を、Godot公式のビルド配布元(`godotengine/godot-builds`)から取得し、公式のSHA512を照合してから使う。サードパーティ製のGodotセットアップ用Actionは使わない。
  - 使用するActionはGitHub公式の `actions/checkout` と `actions/cache`(Godotバイナリのキャッシュ用)だけとし、タグではなくコミットSHAで固定する。
  - スモークテストでは、headlessでのプロジェクトのimport、Autoload `GameManager` の存在、Main Sceneの設定・ロード・インスタンス化、60物理フレームの実行を確認する。
  - 成功条件は「終了コード0」「ログにGodotのエラー出力(`ERROR:` / `SCRIPT ERROR:` / `Parse Error` 等)がない」「`SMOKE_TEST_PASSED` マーカーが出力される」の3つをすべて満たすこととする。
- **判断理由:**
  - Day 3以降の実装に入る前に、PRごとにプロジェクトが壊れていないことを自動で確認できる最低限の基盤を作るため。
  - Godotはパースエラーや `push_error` があっても終了コード0で終わる場合があり、終了コードだけでは失敗を検出できないため。CI①で、意図的な構文エラー・`push_error` が終了コード0のままでも、ログ検出によってCIが失敗として扱えることを確認した。
  - `--check-only --script` ではAutoloadが読み込まれず、`item.gd` で `GameManager` が見つからないという誤検知が出たため、Main Sceneを実際に起動する方式にした。
  - 公式ビルドの直接取得とSHA512照合で、バージョンを固定して再現可能にし、外部Actionへの依存を増やさないため。
  - Ubuntu runnerは起動が速く、headlessのGodot CIの事例が多い。GDScriptのロジックとシーン読み込みはOSへの依存が小さいため。
  - 検証結果: PR上で成功し、PR #9のmerge後にmainへのpushで自動実行されたRun `36967607796` でもPASSした(約14秒、`4.7.2.stable.official.ed1daf0bf`、`SMOKE_TEST_PASSED`)。
- **採用しなかった選択肢:**
  - Godotの終了コードだけで成否を判定する方法(エラーを見逃すため)。
  - `--check-only --script` による構文チェック(Autoloadを読み込まず誤検知するため)。
  - サードパーティ製のセットアップAction(`chickensoft-games/setup-godot` 等)。
  - Windows runner(起動が遅く、現時点でWindows固有の確認対象がないため)。
  - CI①の時点でのテストフレームワーク(GUT / gdUnit4)の導入(Issueの範囲をCI基盤の構築に限定したため)。
- **判断に影響した条件:**
  - 開発環境がWindowsで、Godot CLIがPATHに入っていないこと。
  - `.godot/` がGit管理外のため、CIではimportが必要なこと。
  - リポジトリがPublicで、GitHub Actionsを無料で利用できること。
  - 開発期間の目安が1週間であり、CIはMVP開発を妨げない最小構成にとどめること。
- **再検討条件:**
  - ゲーム機能の単体テスト・統合テストを追加する場合(テストフレームワークの選定を含む)。
  - Godotのバージョンを変更する場合(`GODOT_VERSION` と `GODOT_SHA512` を更新する)。
  - 正常な状態でもGodotがエラー行を出力するようになり、ログ検出で誤検知が起きる場合。
  - Windows固有の確認や書き出し(export)をCIで行う必要が出た場合。

## Decision 014: GeminiによるPR自動レビューを導入する

- **日付:** 2026-10-02
- **状態:** 採用
- **判断内容:**
  - CI②(Issue #12 / PR #13)で、GitHub ActionsからGemini APIを呼び出すPR自動レビュー(`.github/workflows/gemini-review.yml` / `.github/scripts/gemini_review.py` / `.gemini/styleguide.md`)を導入する。
  - main向けPRの作成・更新時(`opened` / `synchronize` / `reopened` / `ready_for_review`)にレビューする。mainへのpush、Draft PR、fork PRでは実行しない。
  - Gemini Interactions API(`https://generativelanguage.googleapis.com/v1beta/interactions`)を使う。認証は `x-goog-api-key` ヘッダー、APIキーはGitHub Actions Secret `GEMINI_API_KEY`、`store: false` を指定する。デフォルトモデルは `gemini-3.8-flash` とし、Repository Variable `GEMINI_MODEL` で変更できるようにする。
  - レビュー結果はPRコメントとして表示する(`VERDICT: NO_ISSUES` / `VERDICT: ISSUES_FOUND`)。同じPRの再レビューでは既存コメントを更新する。
  - GeminiはPRのApprove・Mergeを行わない。最終判断は開発者が行う。
  - Geminiが `ISSUES_FOUND` を返してもworkflowは失敗にしない。Secret未設定・API失敗・レスポンス解析失敗・コメント投稿失敗はworkflowの失敗とする(HTTP 429 / 500 / 503は20秒後・60秒後に再試行する)。
  - workflowの権限は `contents: read` / `issues: read` / `pull-requests: write` とし、`contents: write` は付与しない。
- **判断理由:**
  - CI①(Decision 013)が「プロジェクトが起動・読み込みできるか」を確認するのに対し、CI②には「PRの変更内容を別のAIにレビューしてもらう」役割を持たせるため。
  - 実装担当のAI(Claude Code)とは別のAIによるレビューを入れ、見落としを減らすため(Decision 006の役割分担)。
  - MVPの開発フロー(Issue → ブランチ → PR → レビュー → 開発者のMerge判断)に、AIレビューを自動で組み込むため。
  - **Interactions APIを採用した理由:** 実装時(2026-10)に公式ドキュメントを確認したところ、Interactions APIは2026年6月にGAとなり新規プロジェクトに推奨されており、従来の `generateContent` はlegacy扱い(引き続きサポートはされる)だったため。PR #13の実際のGitHub Actions上で、このAPIによるレビュー生成とPRコメント投稿が正常に動作することを確認している。
  - **PRコメント方式を採用した理由:**
    - レビュー結果をPR上で確認しやすい。
    - GitHubのPR Review(Approve / Request changes)とは分離でき、通常のレビュー作業と混ざらない。
    - Approve・Merge権限をGeminiに与えず、最終判断を人間に残せる。
    - 再レビュー時は既存コメントを更新するため、PRがコメントで埋まらない。
  - **fork PRを対象外とした理由:** Gemini APIキーというSecretを扱うため、fork PRの信頼できないコードをSecret付きのworkflowで実行する構成(`pull_request_target` 等)を避ける。
  - **Geminiの指摘と人間による検証:** PR #13でGeminiレビューを実際に動かしたところ、複数の指摘が出たが、その中には実際の実装・実動確認・公式ドキュメントと一致しない指摘も含まれていた。この経験から、**AIレビューの結果は判断材料であり、最終的な採否は人間が根拠を確認して決定する**という運用方針を明確にする。これはGeminiを否定する判断ではなく、AIレビューを「独立した追加レビュー」として利用し、人間による検証を最終ゲートとするための判断である。
- **採用しなかった選択肢:**
  - Geminiの判断による自動Approve(最終判断を人間に残すため)。
  - 自動Merge(同上。全プロジェクト共通のルールでも禁止している)。
  - Geminiの指摘(`ISSUES_FOUND`)だけでworkflowを失敗させる方式(誤った指摘でもPRがブロックされるため。指摘の採否は人間が判断する)。
  - fork PRに対してSecret付きで実行する方式(`pull_request_target` 等。Secret漏洩のリスクがあるため)。
  - 行単位のインラインレビュー(PR Review API)を今回の段階で導入すること(MVP開発中であり、PRコメント1件で十分なため)。
  - Gemini Code Assist(GitHub App / Developer Connect)を使う方式(Issue #12で、GitHub Actions + Gemini APIの方式に決めたため)。
- **判断に影響した条件:**
  - 個人のPublic GitHubリポジトリであること。
  - 1週間程度の小規模MVPであること。
  - AIを実装・レビューに活用する開発方針であること(Decision 006)。
  - 最終判断は開発者本人が行うこと。
  - Secret(Gemini APIキー)を安全に扱う必要があること。
  - CI①(Decision 013)をすでに導入済みであること。
- **再検討条件:**
  - Private repositoryでの運用が必要になった場合(無料枠では送信内容が製品改善に使われるため、利用プランを含めて再検討する)。
  - 機密情報を扱うプロジェクトになった場合。
  - 行単位のインラインレビューが必要になった場合。
  - Geminiレビューを必須チェック(ブランチ保護)として扱う必要が出た場合。
  - Gemini APIやモデルの仕様が変更された場合(モデルの廃止、Interactions APIの変更等)。
  - レビューのコスト・実行時間、Gemini側の混雑による失敗が問題になった場合。

## Decision 015: 制限時間はMain直下のTimerノード `Time` で管理する

- **日付:** 2026-10-03
- **状態:** 採用
- **判断内容:**
  - Day 3(Issue #16 / PR #17)で、制限時間を管理する `Time` ノードを `Main` の子ノードとして配置する。Autoloadにはしない。
  - `Time` にはGodot標準の `Timer` ノードを使い、`wait_time = 180`、`one_shot = true`、`autostart = true` とする。カウントダウン・0秒での停止・時間切れの通知(`timeout` シグナル)はTimerの標準機能で行い、`Time` にスクリプトは付けない。
  - `Time` は時間の管理だけを担当する。残り時間の表示はUI(`UI`(CanvasLayer)> `TimeLabel`(Label)+ `scripts/time_label.gd`)が担当し、`Time` の `time_left` を読んで `TIME MM:SS` 形式で表示する。
  - `GameManager` は引き続きアイテム取得状態(`has_key` / `has_chart` / `has_flashlight`)だけを管理し、タイマーは扱わない。
- **判断理由:**
  - 必要な機能(カウントダウン・停止・時間切れ通知)がTimerに標準で揃っており、自前のスクリプトを書かずに済むため。
  - 時間の管理と表示を分け、それぞれの役割を明確にするため。
  - `GameManager` の責務を増やさないため(Decision 012の「過剰なゲームマネージャー化を避ける」方針)。
  - 制限時間はMain Sceneでのプレイ中だけ必要で、ゲーム全体で常に存在する必要がないため、Autoloadにはしない。
- **採用しなかった選択肢:**
  - `GameManager` でタイマーを管理する方法。
  - タイマーをAutoloadにする方法。
  - 自前のスクリプトで残り時間を減らしていく方法。
- **判断に影響した条件:**
  - Day 3の範囲は、タイマーと残り時間の表示まで(時間切れ後の処理は後続で実装する)であること。
  - MVPを小さく保ち、過剰設計を避けること。
- **再検討条件:**
  - リスタートやシーン切り替えで、残り時間の扱いが現在の構成では難しくなった場合。
  - 一時停止など、Timerの標準機能では足りない時間の制御が必要になった場合。

## Decision 016: アイテム取得数UIとナースステーションによるクリア条件判定

- **日付:** 2026-10-03
- **状態:** 採用
- **判断内容:**
  - Day 4(Issue #20 / PR #21)で、アイテム取得数UIとクリア条件判定を実装した。
  - 取得数は `GameManager.get_collected_count()` で、既存の3つの取得状態(`has_key` / `has_chart` / `has_flashlight`)から計算する。取得数を新しい状態として保存しない。
  - アイテム取得数UI(`ItemCountLabel`)は、TimeLabel の右隣に `ITEM 0/3`〜`ITEM 3/3` を表示する。
  - GameManager にクリア状態を持たせない。
  - クリア条件の判定は `NurseStation`(Area2D)が行う。
  - クリア条件は「3つのアイテムを取得済み」かつ「制限時間内(`Time.time_left > 0`)」かつ「ナースステーションに入る」。
  - 判定は `body_entered` のときだけ行う。ゲーム開始時は0個のため成立しない。ナースステーションの中で3個目を取得してもその場では判定せず、一度外に出て入り直したときに判定する。
  - 成立したら `clear_condition_met` シグナルを1回だけ発行し、`クリア条件成立` を1回だけ出力する。
  - Day 4 では、クリア後の画面遷移などは実装しない。
- **判断理由:**
  - 取得数の計算を1か所にまとめ、UI と NurseStation で同じ処理を重複させないため。
  - GameManager をゲーム全体の状態管理クラスにしないため(Decision 012・015の方針)。
  - PROJECT_CONTEXT.md 9章の「制限時間内に戻る」と整合させるため。
  - 「入った瞬間」だけ判定するほうが、毎フレームの判定より処理が単純で、開始時の扱いも明確にできるため。
  - クリア後の処理を、Day 5 以降でシグナルにつなげられるようにするため。
- **採用しなかった選択肢:**(いずれも Issue #20 の Phase 1 で検討した案)
  - UI と NurseStation がそれぞれ3つの bool から取得数を数える方式(同じ処理が2か所にできるため)。
  - 時間を見ずに、取得数だけで判定する方式(PROJECT_CONTEXT.md 9章と食い違うため)。
  - 成立したことを何も出力しない方式(Day 4 では画面に何も出ないため、手動で確認できない)。
  - 毎フレーム判定する方式(Issue #20 の確定仕様で、入った瞬間だけ判定すると決めたため)。
  - GameManager にクリア状態を持たせる方式。
- **判断に影響した条件:**
  - Day 4 の範囲は、取得数の表示とクリア条件の判定まで(画面遷移は後続で実装する)であること。
  - ナースステーションはスタート地点 兼 ゴール地点であること(PROJECT_CONTEXT.md 5章)。
  - MVPを小さく保ち、過剰設計を避けること。
- **再検討条件:**
  - クリア画面・ゲームオーバー・リスタートを実装するときに、クリア状態や `clear_condition_met` の扱いが現在の構成では難しくなった場合。
  - アイテムの配置が変わり、ナースステーションの中でアイテムを取得できるようになった場合(中で3個目を取っても判定されない、という扱いを見直す)。
  - クリアに必要な条件が増えた場合。

## Decision 017: ゲーム進行状態はGameFlow(Main の子 Node)で管理する

- **日付:** 2026-10-05
- **状態:** 採用
- **判断内容:**
  - Day 5(Issue #24 / PR #25)で、ゲーム進行状態の管理として `GameFlow`(`scripts/game_flow.gd`)を導入した。`GameFlow` は `Main` の子 Node として配置し、Autoload にはしない。
  - ゲーム進行状態は `PLAYING` / `CLEARED` / `GAME_OVER` の3つとし、GameFlow で管理する。
  - GameManager は引き続きアイテム状態だけを管理する。リスタートのために `reset_items()` だけを GameManager に追加する。
  - NurseStation の `clear_condition_met` と Time の `timeout` は、各コンポーネント自身がゲームの終了状態を変更するのではなく、GameFlow へ通知する。GameFlow が通知を受け取り、現在の状態が `PLAYING` のときだけ終了状態へ遷移する。
  - クリア時は、Player の物理処理を止め(`set_physics_process(false)`)、Timer を一時停止し(`Time.paused = true`。`Time.stop()` は使わない)、Clear 画面を表示する。
  - ゲームオーバー時は、Player の物理処理を止めて Game Over 画面を表示する。
  - 終了状態へ一度遷移したあとは、後から来たクリア・ゲームオーバーのイベントを無視する(最初に成立した終了状態を維持する)。
  - Clear / Game Over 画面の RESTART ボタンで、GameManager のアイテム状態をリセットしてから(`reset_items()`)、Main シーンを読み込み直す(`get_tree().reload_current_scene()`)。RESTART はマウスクリック・Enter・Space で押せる(Godot 標準の Button の操作。Input Map は追加しない)。
- **判断理由:**
  - ゲーム全体の進行状態と、各コンポーネント固有の責務を分けるため。特に GameManager をゲーム全体の状態管理に広げず、「アイテム状態を管理する」という既存の役割を維持する(Decision 012・015・016 の方針)。
  - NurseStation や Time が直接画面を切り替えるのではなく、GameFlow を経由させることで、クリアとゲームオーバーの競合を防ぎ、ゲームの進行を1か所で管理できるようにするため。
  - ゲームの進行はプレイ中の Main シーンにだけ必要なため、Autoload にはしない。
  - Player は移動の責務に限定し、ゲームの状態管理を持ち込まないため(Player の停止は GameFlow から行う)。
  - クリア後に `TIME 00:00` と表示されて時間切れと誤解されるのを防ぐため(`paused` を採用)。
  - GameManager は Autoload で、シーンを読み込み直しても状態が残るため、リスタート時に明示的に初期化する。
- **採用しなかった選択肢:**(いずれも Issue #24 の仕様作成時に候補として挙げ、採用しなかったもの)
  - GameManager にゲーム進行状態を持たせる方式(GameManager の責務が大きくなるため)。
  - Main ノード自体にスクリプトを付けて進行状態を管理する方式(Issue #24 で GameFlow ノードと並べた候補。役割の名前と置き場所を一致させるため、GameFlow ノードとして分けた)。
  - クリア時に `Time.stop()` で Timer を止める方式(`TIME 00:00` と表示されるため)。
  - ゲーム全体を一時停止する方式(`get_tree().paused`。UI だけ動かす設定が必要になり、Timer やアイテムにも影響するなど、影響範囲が広いため)。
  - Player のスクリプトにゲームの状態管理を移す方式(Player の責務を移動に限定するため)。
  - RESTART をマウスクリックだけにする方式、専用キー(例:R)を Input Map に追加する方式(ボタン + 標準の `ui_accept` で、クリック・Enter・Space のどれでも押せるため)。
- **判断に影響した条件:**
  - Day 5 の範囲は、MVP の完成に必要なクリア画面・ゲームオーバー・リスタートまでであること。
  - Day 4 のクリア条件(Decision 016)は変更しないこと。
  - MVPを小さく保ち、過剰設計を避けること。
- **再検討条件:**
  - 複数ステージを実装する場合。
  - セーブ・ロードを実装する場合。
  - 一時停止メニューなど、`PLAYING` / `CLEARED` / `GAME_OVER` 以外の複雑なゲーム状態が必要になった場合。
  - タイトル画面やステージ遷移など、Main 以外のシーンをまたぐゲーム進行が必要になった場合。
  - ゲーム進行状態を大きく拡張する場合。
  - リスタートで、シーンの読み込み直しでは初期化できない状態(Autoload の新しい状態など)が増えた場合。

## Decision 018: CI③としてClaude CodeによるIssue→実装→PR作成の自動化を導入する

- **日付:** 2026-10-05
- **状態:** 採用
- **判断内容:**
  - CI③(Issue #28 / PR #29)として、`.github/workflows/claude-issue-implement.yml` と `.github/scripts/claude_issue_automation.py` を導入する。CI①・CI②は置き換えない。
  - Issue に `claude-ready` ラベルが付いたとき(`issues: labeled`)だけ実行する。`claude-ready` は、内容を確認した開発者が付ける「実装開始の明示的な GO」とし、Issue の作成だけでは動かさない。
  - `guard` ジョブで、ラベル・Issue であること・Issue が open・ラベルを付けた人が書き込み権限を持つ人間であること・同じ Issue の open PR や `claude/issue-<N>` ブランチがないこと、を確認してから実行する。
  - `implement` ジョブで、workflow が `main` から `claude/issue-<N>` を作り、`anthropics/claude-code-action`(v1、agent mode)が実装・テスト・commit する。Claude Code に許可するツールは、ファイルの読み書き・`git status/diff/log/add/commit`・スモークテスト・`godot` に限定し、push・Web アクセスは許可しない。
  - push は Claude Code ではなく workflow が行う。作業ブランチ・未 commit の変更・commit の有無・`.github/` 配下の変更を確認してから、`claude/issue-<N>` にだけ push する(強制 push はしない)。
  - `create-pr` ジョブで、GitHub App `night-shift-escape-pr-creator` の Installation Access Token(`actions/create-github-app-token` v3、`client-id` 方式)を使って PR を作成する。base `main`、Draft ではない、本文に `Closes #<N>`。
  - workflow 全体の権限は `{}` とし、ジョブごとに必要な分だけ付ける。アクションはコミット SHA で固定する。
  - 自動 Merge はしない。失敗しても、作成済みのブランチは削除しない。
- **判断理由:**
  - ChatGPT で確定した Issue の内容を Claude Code へ手動でコピーする手間を減らすため。
  - 実装開始の判断を開発者に残すため、Issue の作成ではなく、明示的なラベルの付与を起動条件にする。
  - Public リポジトリのため、Issue 本文を信頼できる命令として扱わず、書き込み権限・ツールの制限・push 前の確認など、プロンプト以外の仕組みでも逸脱を防ぐため。
  - `git push` の許可は書き方の都合で `main` への push を防ぎきれないため、push は workflow 側で確認してから行う。
  - `GITHUB_TOKEN` で作成した PR では後続の `pull_request` workflow(CI①・CI②)が承認待ちになり、自動で実行されないため、PR の作成には GitHub App のトークンを使う。App の権限は PR の作成に必要な最小限(Contents: Read-only、Pull requests: Read & write、Metadata: Read-only)にする。
  - 二重実行で既存の作業を壊さないよう、既存のブランチ・open PR があれば実行しない(安全側に倒す)。
- **採用しなかった選択肢:**(いずれも Issue #28 / PR #29 で検討したもの)
  - Issue の作成時に自動で起動する方式(実装開始を開発者が明示的に判断するため)。
  - Claude Code 自身に `git push` させる方式(`main` への push を確実に防げないため)。
  - Claude Code 側で PR を作成する方式(PR の作成は後段の処理に分け、Claude Code に PR 作成の権限・目的を持たせない)。
  - `GITHUB_TOKEN` で PR を作成する方式(CI①・CI② が承認待ちになるため)。
  - Personal Access Token(PAT)で PR を作成する方式(有効期間の長い秘密情報になるため。Issue #28 で不採用と決定)。
  - 公式の Claude GitHub App で Claude Code を動かす方式(ジョブの短命な `GITHUB_TOKEN`(`contents: write` のみ)で足りるため)。
  - 自動 Merge(最終判断を開発者に残すため。全プロジェクト共通のルールでも禁止している)。
- **判断に影響した条件:**
  - 個人の Public GitHub リポジトリであること。
  - AI を実装・レビューに活用する開発方針であること(Decision 006)。
  - CI①(Decision 013)・CI②(Decision 014)をすでに導入済みであること。
  - CI③ 自身の workflow は `main` に入るまで起動できないため、最初の導入は従来の手動フローで行う必要があったこと。
- **再検討条件:**
  - Claude Code の実行結果(スモークテストの成否、拒否されたツールの使用など)をログから確認できる仕組みが必要になった場合。
  - `main` にブランチ保護・ルールセットを設定する場合。
  - Claude Code Action・`actions/create-github-app-token` の仕様が変わった場合。
  - 複数の Issue を並行して自動実装する運用が必要になった場合。
  - 誤った実装や意図しない変更が自動で作られる問題が起きた場合。

## Decision 019: CI③のClaude Codeの認証をOAuth Token方式にする

- **日付:** 2026-10-06
- **状態:** 採用
- **判断内容:**
  - CI③ の Claude Code Action の認証に、Claude のサブスクリプションにひもづく OAuth Token(`claude_code_oauth_token` 入力、Repository Secret `CLAUDE_CODE_OAUTH_TOKEN`、`claude setup-token` で生成)を使う(Issue #30 / PR #31)。
  - Anthropic API キー(`anthropic_api_key` / `ANTHROPIC_API_KEY`)は使わない。
  - Secret が未設定の場合は、ブランチを作る前に workflow を止める。Token の値はログ・リポジトリに出さない。
- **判断理由:**
  - Anthropic API の従量課金を使わず、開発者の Claude Pro 契約の範囲で CI③ を動かすため。公式ドキュメントでは、OAuth Token で認証すると、実行は API 課金ではなくサブスクリプションを使う。
  - OAuth Token は Pro / Max / Team / Enterprise プランで使える、Claude Code Action の公式にサポートされた認証方式であるため。
- **採用しなかった選択肢:**
  - Anthropic API キーを使う方式(PR #29 で最初に実装したが、API の従量課金になるため PR #31 で変更した。なお、Repository Secret `ANTHROPIC_API_KEY` は一度も登録していない)。
  - Workload Identity Federation(静的な鍵を置かずに済むが、Claude Console の組織側の設定が必要で、API の利用になるため)。
- **判断に影響した条件:**
  - 開発者が Claude Pro を契約していること。
  - 個人開発で、API の従量課金を避けたいこと。
- **再検討条件:**
  - OAuth Token の利用条件・Claude Code Action の認証方式が変わった場合。
  - サブスクリプションの利用枠では CI③ の実行が足りなくなった場合。
  - 複数のリポジトリや複数の開発者で CI③ を共有する場合(公式ドキュメントでは、共有には個人のサブスクリプションにひもづく OAuth Token ではなく API キーを推奨している)。
