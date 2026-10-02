extends SceneTree
## CI用のスモークテスト。Godotをheadlessで起動し、Main Sceneが読み込めることだけを確認する。
## 実行: godot --headless --path . -s res://tests/smoke/smoke_test.gd
## ゲームの操作(移動・衝突・アイテム取得)は確認しない。

# Main Sceneを動かしておくフレーム数。_ready や _physics_process が一通り走れば十分。
const RUN_FRAMES: int = 60
# 成功時だけ最後に出力する目印。run_smoke_test.sh はこの文字列があるかも確認する。
const PASS_MARKER: String = "SMOKE_TEST_PASSED"

var _failed: bool = false


# SceneTree のスクリプトでは _ready が呼ばれないため、_initialize から始める。
func _initialize() -> void:
	_run.call_deferred()


func _run() -> void:
	# Autoload が登録されているか(project.godot の [autoload])。
	_check(root.get_node_or_null("GameManager") != null, "Autoload GameManager が見つからない")

	# project.godot に設定されている Main Scene を、実際の起動時と同じように読み込む。
	var main_scene_path: String = ProjectSettings.get_setting("application/run/main_scene", "")
	_check(main_scene_path != "", "Main Scene が設定されていない")
	var packed: PackedScene = load(main_scene_path) as PackedScene
	_check(packed != null, "Main Scene を読み込めない: %s" % main_scene_path)
	if _failed:
		_finish()
		return

	var main: Node = packed.instantiate()
	root.add_child(main)
	current_scene = main

	for i in RUN_FRAMES:
		await physics_frame

	_finish()


func _check(condition: bool, message: String) -> void:
	if not condition:
		_failed = true
		printerr("SMOKE TEST FAILED: %s" % message)


func _finish() -> void:
	if _failed:
		quit(1)
		return
	print(PASS_MARKER)
	quit(0)
