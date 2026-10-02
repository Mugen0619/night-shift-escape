extends Area2D
## ナースステーション(スタート地点 兼 ゴール地点)。
## プレイヤーが入った瞬間に、3つのアイテムをすべて持っていて、まだ時間が残っていれば、
## クリア条件が成立したことを知らせる。

# クリア条件が成立したときに1回だけ発行する。Day 5 以降でクリア画面などをつなぐ。
signal clear_condition_met

# クリアに必要なアイテム数(鍵・カルテ・懐中電灯)
const REQUIRED_ITEM_COUNT: int = 3

# 残り時間を読む Timer(main.tscn で Time ノードを指定する)。値は読むだけで変更しない。
@export var time: Timer

# 一度成立したら、再び入っても発行しないための印。
var _is_cleared: bool = false


func _ready() -> void:
	# 毎フレームではなく「入った瞬間」だけ判定するため、body_entered シグナルを使う。
	# 開始時はプレイヤーがすでに中にいるので、最初の物理フレームで1回呼ばれる(このときは0個なので成立しない)。
	body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group("player"):
		return
	if _is_cleared:
		return
	if GameManager.get_collected_count() != REQUIRED_ITEM_COUNT:
		return
	# 時間切れのあと(Timer が止まって time_left が 0)は成立させない。
	if time.time_left <= 0.0:
		return

	_is_cleared = true
	print("クリア条件成立")
	clear_condition_met.emit()
