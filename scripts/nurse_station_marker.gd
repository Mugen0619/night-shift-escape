extends Node2D
## ナースステーションを「ゴール地点」だと分かるようにする目印(見た目だけ)。
## 判定エリアの床をうっすら色付けし、四隅の強調と「GOAL」の札・矢印を描く。
## 判定には関わらない(NurseStation の子として置く)。

const AREA := Rect2(-128, -80, 256, 160)  # NurseStation の判定範囲(ローカル座標)
const OUTLINE := Color("26303c")
const GOAL_GREEN := Color("3fae7a")
const GOAL_LIGHT := Color("e8fff3")


func _draw() -> void:
	# 判定エリアの床をうっすら緑に(プレイヤーの視認性を落とさないよう淡く)
	draw_rect(AREA, Color(0.25, 0.8, 0.5, 0.12))
	# 四隅の強調
	for corner in [AREA.position, Vector2(AREA.end.x, AREA.position.y), Vector2(AREA.position.x, AREA.end.y), AREA.end]:
		var sx: float = 1.0 if corner.x == AREA.position.x else -1.0
		var sy: float = 1.0 if corner.y == AREA.position.y else -1.0
		draw_line(corner, corner + Vector2(18 * sx, 0), GOAL_GREEN, 4.0)
		draw_line(corner, corner + Vector2(0, 18 * sy), GOAL_GREEN, 4.0)

	# 「GOAL」の札(エリア上端の少し上)と、下向きの矢印
	var badge := Rect2(-40, -118, 80, 24)
	draw_rect(badge.grow(2), OUTLINE)
	draw_rect(badge, GOAL_GREEN)
	var font: Font = ThemeDB.fallback_font
	draw_string(font, Vector2(badge.position.x, badge.position.y + 17), "GOAL",
		HORIZONTAL_ALIGNMENT_CENTER, badge.size.x, 16, GOAL_LIGHT)
	draw_colored_polygon(PackedVector2Array([Vector2(-8, -92), Vector2(8, -92), Vector2(0, -81)]), OUTLINE)
	draw_colored_polygon(PackedVector2Array([Vector2(-5, -92), Vector2(5, -92), Vector2(0, -85)]), GOAL_GREEN)
