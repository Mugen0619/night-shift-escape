extends Node
## ゲームの進行状態(PLAYING / CLEARED / GAME_OVER)を管理し、
## クリア・ゲームオーバー・リスタートの処理と、終了画面の表示を担当する。
## アイテム取得状態は GameManager、クリア条件の判定は NurseStation が担当し、ここでは扱わない。

enum State { PLAYING, CLEARED, GAME_OVER }

# main.tscn で各ノードを指定する。
@export var player: CharacterBody2D
@export var time: Timer
@export var nurse_station: Area2D
@export var clear_screen: Control
@export var clear_restart_button: Button
@export var game_over_screen: Control
@export var game_over_restart_button: Button

var state: State = State.PLAYING


func _ready() -> void:
	clear_screen.hide()
	game_over_screen.hide()
	nurse_station.clear_condition_met.connect(_on_clear_condition_met)
	time.timeout.connect(_on_time_timeout)
	clear_restart_button.pressed.connect(_on_restart_pressed)
	game_over_restart_button.pressed.connect(_on_restart_pressed)


func _on_clear_condition_met() -> void:
	# 先に成立した終了状態を採用する。すでに終了していれば何もしない。
	if state != State.PLAYING:
		return
	state = State.CLEARED
	SoundEffects.play_clear()
	_stop_player()
	# stop() だと time_left が 0 になり「TIME 00:00」と表示されるため、
	# paused で止めて、クリアした時点の残り時間を表示したままにする。
	time.paused = true
	_show_end_screen(clear_screen, clear_restart_button)


func _on_time_timeout() -> void:
	if state != State.PLAYING:
		return
	state = State.GAME_OVER
	SoundEffects.play_game_over()
	_stop_player()
	_show_end_screen(game_over_screen, game_over_restart_button)


# プレイヤーの物理処理(入力 → 移動)を止めて、操作できないようにする。
# player.gd には手を入れず、ゲームの進行を管理するこちら側から止める。
func _stop_player() -> void:
	player.set_physics_process(false)


func _show_end_screen(screen: Control, restart_button: Button) -> void:
	screen.show()
	# フォーカスを当てておくと、Enter / Space(Godot 標準の ui_accept)でも押せる。
	restart_button.grab_focus()


func _on_restart_pressed() -> void:
	# GameManager は Autoload なのでシーンを読み込み直しても状態が残る。先に初期化する。
	GameManager.reset_items()
	SoundEffects.play_restart()
	get_tree().reload_current_scene()
