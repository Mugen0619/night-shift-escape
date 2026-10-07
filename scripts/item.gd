extends Area2D
## マップ上のアイテム。プレイヤーが触れると GameManager に取得を伝えて消える。
## 3種類とも同じシーン(item.tscn)を使い、item_type だけを変えて配置する。

# 見た目は種類ごとに、色と形(図形のアイコン)で描き分ける(画像素材は使わない)。
const OUTLINE := Color("26303c")
const KEY_GOLD := Color(1.0, 0.85, 0.2)
const KEY_DARK := Color(0.75, 0.55, 0.05)
const PAPER := Color(0.97, 0.97, 0.95)
const CHART_BOARD := Color(0.2, 0.55, 0.85)
const LINE := Color(0.45, 0.5, 0.55)
const LIGHT_BODY := Color(1.0, 0.5, 0.1)
const LIGHT_DARK := Color(0.75, 0.33, 0.05)
const BEAM := Color(1.0, 0.95, 0.5, 0.55)

# インスペクターで選べるようにする(main.tscn で配置ごとに設定)。
@export_enum("key", "chart", "flashlight") var item_type: String = "key"


func _ready() -> void:
	# Area2D は「重なった」ことを検知するだけで、プレイヤーの移動は妨げない。
	body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node2D) -> void:
	# 壁など、プレイヤー以外の物体には反応しない。
	if not body.is_in_group("player"):
		return
	GameManager.collect_item(item_type)
	# ノードごと削除するので、同じアイテムをもう一度取得することはない。
	queue_free()


# 当たり判定(24x24)とほぼ同じ範囲に、種類ごとのアイコンを描く。
func _draw() -> void:
	# 丸い台座:床や家具と区別して、拾えるものだと分かるようにする。
	draw_circle(Vector2.ZERO, 14.0, OUTLINE)
	draw_circle(Vector2.ZERO, 12.0, Color(1, 1, 1, 0.85))
	match item_type:
		"key":
			_draw_key()
		"chart":
			_draw_chart()
		"flashlight":
			_draw_flashlight()


# 鍵: 金色の輪(持ち手)・軸・歯
func _draw_key() -> void:
	draw_circle(Vector2(-5, 0), 6.0, OUTLINE)
	draw_circle(Vector2(-5, 0), 4.5, KEY_GOLD)
	draw_circle(Vector2(-5, 0), 1.8, Color(1, 1, 1, 0.85))
	draw_rect(Rect2(0, -2, 11, 4), OUTLINE)
	draw_rect(Rect2(1, -1, 9, 2), KEY_GOLD)
	draw_rect(Rect2(6, 1, 3, 5), OUTLINE)
	draw_rect(Rect2(7, 1, 1, 4), KEY_DARK)


# カルテ: 青いバインダーに白い紙と文字の線
func _draw_chart() -> void:
	draw_rect(Rect2(-7, -9, 14, 18), OUTLINE)
	draw_rect(Rect2(-6, -8, 12, 16), CHART_BOARD)
	draw_rect(Rect2(-4, -5, 8, 12), PAPER)
	for i in 3:
		draw_rect(Rect2(-3, -3 + i * 3, 6, 1), LINE)
	draw_rect(Rect2(-3, -10, 6, 3), OUTLINE)  # クリップ
	draw_rect(Rect2(-2, -9, 4, 1), Color(0.8, 0.8, 0.8))


# 懐中電灯: 斜めに置いたオレンジの本体と、光の先端
func _draw_flashlight() -> void:
	draw_set_transform(Vector2.ZERO, deg_to_rad(-35.0))
	draw_colored_polygon(PackedVector2Array([Vector2(7, -3), Vector2(13, -7), Vector2(13, 7), Vector2(7, 3)]), BEAM)
	draw_rect(Rect2(-10, -3, 14, 6), OUTLINE)
	draw_rect(Rect2(-9, -2, 12, 4), LIGHT_BODY)
	draw_rect(Rect2(-9, 1, 12, 1), LIGHT_DARK)
	draw_rect(Rect2(3, -5, 5, 10), OUTLINE)  # ヘッド部分
	draw_rect(Rect2(4, -4, 3, 8), Color(1.0, 0.95, 0.6))
	draw_set_transform(Vector2.ZERO, 0.0)
