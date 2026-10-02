#!/usr/bin/env bash
# Godotをheadlessで動かすスモークテスト。CI(Ubuntu)とローカル(Windows の Git Bash)の両方で使う。
#
#   GODOT=<Godotの実行ファイル> bash tests/smoke/run_smoke_test.sh
#
# Godotはスクリプトエラーがあっても終了コード0で終わることがあるため、
# 次の3つをすべて満たしたときだけ成功とする。
#   1. 終了コードが0
#   2. ログにGodotのエラー行がない
#   3. smoke_test.gd が最後に出す目印(SMOKE_TEST_PASSED)がある
set -uo pipefail

GODOT="${GODOT:?環境変数GODOTにGodotの実行ファイルのパスを指定してください}"
cd "$(dirname "$0")/../.."

# Godotのエラー出力の書式(ERROR: / SCRIPT ERROR: / USER ERROR: など)と、パース・コンパイルエラー。
ERROR_PATTERN='^(USER |SCRIPT |USER SCRIPT )?ERROR:|Parse Error|Compile Error'

LOG_DIR="$(mktemp -d)"
failed=0

# $1: ステップ名, $2以降: Godotに渡す引数
run_godot() {
	local name="$1"
	shift
	local log="$LOG_DIR/$name.log"
	echo "::group::$name"
	"$GODOT" --headless --path . "$@" >"$log" 2>&1
	local code=$?
	cat "$log"
	echo "::endgroup::"

	local result=0
	if [ "$code" -ne 0 ]; then
		echo "[$name] 終了コードが0ではありません: $code"
		result=1
	fi
	if grep -nE "$ERROR_PATTERN" "$log"; then
		echo "[$name] ログにGodotのエラーがあります(上の行)"
		result=1
	fi
	if [ "$result" -ne 0 ]; then
		failed=1
	fi
	return "$result"
}

"$GODOT" --headless --version

# 1. import: .godot/(Git管理外)を作り、スクリプトのクラスやリソースを登録する。
run_godot import --import

# 2. Main Sceneを読み込んで数フレーム動かす。
if run_godot smoke -s res://tests/smoke/smoke_test.gd; then
	if ! grep -q "SMOKE_TEST_PASSED" "$LOG_DIR/smoke.log"; then
		echo "[smoke] 成功の目印 SMOKE_TEST_PASSED が出力されていません"
		failed=1
	fi
fi

if [ "$failed" -ne 0 ]; then
	echo "Smoke test: FAILED"
	exit 1
fi
echo "Smoke test: PASSED"
