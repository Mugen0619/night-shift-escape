extends Node2D
## 病院マップの見た目(ピクセルアート調)を描く。見た目だけで、衝突判定・ゲームロジックには関わらない。
## 外部素材は使わず、四角形だけでオリジナルのドット絵風に描く。
## layer が "floor" のときは床・家具・設備、"wall_trim" のときは壁の縁取りを描く。

@export var layer: String = "floor"

# 白〜青灰色を基調にした落ち着いた配色
const FLOOR_A := Color(0.74, 0.80, 0.84)
const FLOOR_B := Color(0.70, 0.76, 0.81)
const FLOOR_LINE := Color(0.62, 0.69, 0.75)
const ROOM_A := Color(0.80, 0.85, 0.88)
const ROOM_B := Color(0.77, 0.82, 0.86)
const NURSE_A := Color(0.66, 0.74, 0.80)
const NURSE_B := Color(0.63, 0.71, 0.78)
const OUTLINE := Color(0.14, 0.19, 0.26)
const WALL_DARK := Color(0.24, 0.31, 0.39)
const WALL_LIGHT := Color(0.86, 0.91, 0.94)
const WHITE := Color(0.93, 0.96, 0.97)
const GRAY := Color(0.72, 0.77, 0.81)
const BLUE := Color(0.50, 0.63, 0.74)
const DARK_BLUE := Color(0.31, 0.40, 0.50)
const SCREEN := Color(0.45, 0.78, 0.78)
const PLANT := Color(0.33, 0.52, 0.45)
const PLANT_DARK := Color(0.22, 0.38, 0.34)
const POT := Color(0.55, 0.50, 0.50)

const TILE := 32
const MAP_SIZE := Vector2(1152, 648)


func _draw() -> void:
	if layer == "wall_trim":
		_draw_wall_trim()
		return
	_draw_floor()
	_draw_nurse_counter()
	# 左上の部屋
	_bed(Vector2(52, 52))
	_monitor(Vector2(132, 54))
	_cabinet(Vector2(300, 40))
	_plant(Vector2(344, 190))
	# 右上の部屋
	_bed(Vector2(450, 52))
	_monitor(Vector2(530, 54))
	_bed(Vector2(820, 52))
	_monitor(Vector2(900, 54))
	_locker_row(Vector2(660, 36), 4)
	_desk(Vector2(980, 220))
	_chair(Vector2(1000, 258))
	_cart(Vector2(1040, 330))
	_plant(Vector2(1080, 60))
	# 左下
	_locker_row(Vector2(52, 580), 4)
	_chair(Vector2(220, 586))
	_chair(Vector2(260, 586))
	_chair(Vector2(300, 586))
	_plant(Vector2(350, 470))
	# 下の中央と右下
	_plant(Vector2(630, 570))
	_cart(Vector2(860, 570))
	_bed(Vector2(960, 540))
	_monitor(Vector2(1044, 542))


func _rect(x: float, y: float, w: float, h: float, color: Color) -> void:
	draw_rect(Rect2(x, y, w, h), color)


# 外枠つきの箱(濃い輪郭 + 塗り + 上側のハイライト)
func _box(pos: Vector2, size: Vector2, fill: Color, light: Color) -> void:
	_rect(pos.x, pos.y, size.x, size.y, OUTLINE)
	_rect(pos.x + 3, pos.y + 3, size.x - 6, size.y - 6, fill)
	_rect(pos.x + 3, pos.y + 3, size.x - 6, 3, light)


func _tiles(area: Rect2, a: Color, b: Color) -> void:
	var y := area.position.y
	var row := 0
	while y < area.end.y:
		var x := area.position.x
		var col := 0
		var h := minf(TILE, area.end.y - y)
		while x < area.end.x:
			var w := minf(TILE, area.end.x - x)
			_rect(x, y, w, h, a if (row + col) % 2 == 0 else b)
			# 薄いタイル境界線
			_rect(x, y, w, 1, FLOOR_LINE)
			_rect(x, y, 1, h, FLOOR_LINE)
			x += TILE
			col += 1
		y += TILE
		row += 1


func _draw_floor() -> void:
	# 廊下
	_tiles(Rect2(Vector2.ZERO, MAP_SIZE), FLOOR_A, FLOOR_B)
	# 病室・診察エリア
	_tiles(Rect2(416, 32, 704, 382), ROOM_A, ROOM_B)
	_tiles(Rect2(32, 32, 352, 212), ROOM_A, ROOM_B)
	# ナースステーション
	_tiles(Rect2(40, 232, 320, 184), NURSE_A, NURSE_B)
	_rect(40, 232, 320, 3, DARK_BLUE)
	_rect(40, 413, 320, 3, DARK_BLUE)


func _draw_nurse_counter() -> void:
	_box(Vector2(90, 244), Vector2(220, 36), GRAY, WHITE)
	# カウンター上のモニターと書類
	_box(Vector2(110, 248), Vector2(32, 20), DARK_BLUE, SCREEN)
	_rect(220, 254, 24, 14, WHITE)
	_rect(222, 258, 20, 2, BLUE)
	_rect(222, 262, 14, 2, BLUE)


func _bed(pos: Vector2) -> void:
	_box(pos, Vector2(72, 44), WHITE, WALL_LIGHT)
	# 枕と毛布
	_rect(pos.x + 6, pos.y + 8, 16, 28, Color(0.82, 0.88, 0.92))
	_rect(pos.x + 30, pos.y + 8, 36, 28, BLUE)
	_rect(pos.x + 30, pos.y + 8, 36, 3, Color(0.62, 0.74, 0.83))


func _monitor(pos: Vector2) -> void:
	# ベッド脇の医療機器(モニター付きスタンド)
	_box(pos, Vector2(24, 30), GRAY, WHITE)
	_rect(pos.x + 5, pos.y + 6, 14, 10, DARK_BLUE)
	_rect(pos.x + 7, pos.y + 10, 10, 2, SCREEN)
	_rect(pos.x + 5, pos.y + 20, 6, 4, BLUE)


func _cabinet(pos: Vector2) -> void:
	_box(pos, Vector2(60, 28), GRAY, WHITE)
	_rect(pos.x + 29, pos.y + 6, 2, 18, OUTLINE)
	_rect(pos.x + 22, pos.y + 14, 4, 3, DARK_BLUE)
	_rect(pos.x + 34, pos.y + 14, 4, 3, DARK_BLUE)


func _locker_row(pos: Vector2, count: int) -> void:
	for i in count:
		var p := pos + Vector2(i * 30, 0)
		_box(p, Vector2(30, 32), BLUE, Color(0.66, 0.77, 0.85))
		_rect(p.x + 8, p.y + 10, 14, 2, OUTLINE)
		_rect(p.x + 8, p.y + 15, 14, 2, OUTLINE)
		_rect(p.x + 20, p.y + 22, 3, 4, WHITE)


func _desk(pos: Vector2) -> void:
	_box(pos, Vector2(80, 32), Color(0.78, 0.82, 0.84), WHITE)
	_box(pos + Vector2(10, 4), Vector2(22, 16), DARK_BLUE, SCREEN)
	_rect(pos.x + 50, pos.y + 10, 20, 12, WHITE)


func _chair(pos: Vector2) -> void:
	_box(pos, Vector2(24, 24), DARK_BLUE, BLUE)
	_rect(pos.x + 4, pos.y + 4, 16, 5, OUTLINE)


func _cart(pos: Vector2) -> void:
	# 医療用カート
	_box(pos, Vector2(40, 28), WHITE, WALL_LIGHT)
	_rect(pos.x + 6, pos.y + 12, 28, 2, BLUE)
	_rect(pos.x + 6, pos.y + 18, 28, 2, BLUE)
	_rect(pos.x + 4, pos.y + 28, 6, 4, OUTLINE)
	_rect(pos.x + 30, pos.y + 28, 6, 4, OUTLINE)


func _plant(pos: Vector2) -> void:
	_rect(pos.x + 2, pos.y + 18, 20, 16, OUTLINE)
	_rect(pos.x + 5, pos.y + 20, 14, 11, POT)
	_rect(pos.x, pos.y + 4, 24, 16, PLANT_DARK)
	_rect(pos.x + 3, pos.y + 2, 18, 14, PLANT)
	_rect(pos.x + 8, pos.y - 2, 8, 8, PLANT)


# 壁の縁取り(衝突判定の位置・大きさと同じ範囲の内側に描く)
func _draw_wall_trim() -> void:
	# 外壁
	_trim(Rect2(0, 0, 1152, 32))
	_trim(Rect2(0, 616, 1152, 32))
	_trim(Rect2(0, 0, 32, 648))
	_trim(Rect2(1120, 0, 32, 648))
	# 内壁
	_trim(Rect2(384, 70, 32, 300))
	_trim(Rect2(600, 414, 300, 32))


func _trim(r: Rect2) -> void:
	_rect(r.position.x, r.position.y, r.size.x, r.size.y, OUTLINE)
	_rect(r.position.x + 2, r.position.y + 2, r.size.x - 4, r.size.y - 4, WALL_DARK)
	_rect(r.position.x + 4, r.position.y + 4, r.size.x - 8, 6, WALL_LIGHT)
	# 壁の継ぎ目
	var step := 32
	if r.size.x >= r.size.y:
		var x := r.position.x + step
		while x < r.end.x:
			_rect(x, r.position.y + 10, 2, r.size.y - 14, OUTLINE)
			x += step
	else:
		var y := r.position.y + step
		while y < r.end.y:
			_rect(r.position.x + 4, y, r.size.x - 8, 2, OUTLINE)
			y += step
