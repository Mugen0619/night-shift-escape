extends Node2D
## 病院マップの見た目(床・壁・家具・医療設備・ナースステーション)を、Godot標準の描画(_draw)だけで描く。
## 見た目だけを担当し、衝突判定・ゲームロジックには関わらない(外部アセットも使わない)。
## Main の最初の子として置き、プレイヤー・アイテムより奥に表示する。

# --- パレット(白〜ライトブルーグレー〜ダークブルーグレーに限定) ---
const OUTLINE := Color("26303c")
const WALL_CAP := Color("e4ecf2")
const WALL_FACE := Color("b4c3d1")
const WALL_SIDE := Color("7c8da0")
const FLOOR_A := Color("d6e0e8")
const FLOOR_B := Color("ccd8e2")
const FLOOR_LINE := Color("b9c7d3")
const ZONE_A := Color("b9d0e0")
const ZONE_B := Color("afc8da")
const WHITE := Color("f2f6f9")
const LIGHT := Color("d9e3ea")
const MID := Color("a3b4c4")
const DARK := Color("5d6e80")
const SCREEN := Color("22303a")
const SCREEN_LINE := Color("6fb3a8")
const WOOD := Color("8f8a86")
const WOOD_DARK := Color("6b6764")
const BLANKET := Color("8fb0cc")
const BLANKET_DARK := Color("6f90ae")
const LEAF := Color("5f8a7a")
const LEAF_DARK := Color("46695d")

const TILE: int = 32
const MAP_SIZE := Vector2(1152, 648)

# 衝突判定(main.tscn の Walls)と同じ範囲。見た目をこれに合わせて描く。
const WALL_RECTS: Array[Rect2] = [
	Rect2(0, 0, 1152, 32),
	Rect2(0, 616, 1152, 32),
	Rect2(0, 0, 32, 648),
	Rect2(1120, 0, 32, 648),
	Rect2(384, 70, 32, 300),
	Rect2(600, 414, 300, 32),
]
const STATION_RECT := Rect2(72, 244, 256, 160)


func _draw() -> void:
	_draw_floor()
	_draw_station_zone()
	_draw_light_pools()
	for r in WALL_RECTS:
		_draw_wall_shadow(r)
	_draw_furniture()
	_draw_station()
	for r in WALL_RECTS:
		_draw_wall(r)


# ---------- 基本部品 ----------

func _px(r: Rect2, c: Color) -> void:
	draw_rect(r, c)


# 輪郭(2px)・本体・上のハイライト・下の影を持つ箱。単色の矩形に見えないようにする基本部品。
func _box(r: Rect2, fill: Color, hi: Color, shade: Color) -> void:
	_px(r, OUTLINE)
	var inner := r.grow(-2)
	if inner.size.x <= 0 or inner.size.y <= 0:
		return
	_px(inner, fill)
	_px(Rect2(inner.position, Vector2(inner.size.x, minf(2, inner.size.y))), hi)
	var sh := minf(3, inner.size.y / 2)
	_px(Rect2(inner.position.x, inner.end.y - sh, inner.size.x, sh), shade)


func _ellipse(center: Vector2, radius: Vector2, c: Color) -> void:
	var pts := PackedVector2Array()
	for i in 24:
		var a := TAU * i / 24.0
		pts.append(center + Vector2(cos(a) * radius.x, sin(a) * radius.y))
	draw_colored_polygon(pts, c)


# ---------- 床・壁 ----------

func _draw_floor() -> void:
	for ty in int(MAP_SIZE.y / TILE) + 1:
		for tx in int(MAP_SIZE.x / TILE) + 1:
			var c := FLOOR_A if (tx + ty) % 2 == 0 else FLOOR_B
			_px(Rect2(tx * TILE, ty * TILE, TILE, TILE), c)
			# 目立ちすぎないタイル目地(上と左の1px)
			_px(Rect2(tx * TILE, ty * TILE, TILE, 1), FLOOR_LINE)
			_px(Rect2(tx * TILE, ty * TILE, 1, TILE), FLOOR_LINE)
			# タイルの小さなハイライト
			_px(Rect2(tx * TILE + 3, ty * TILE + 3, 4, 1), WHITE)


# ナースステーションの床(クリア判定エリアの位置を、床の色で示す)
func _draw_station_zone() -> void:
	for ty in int(STATION_RECT.size.y / TILE) + 1:
		for tx in int(STATION_RECT.size.x / TILE):
			var r := Rect2(STATION_RECT.position + Vector2(tx * TILE, ty * TILE), Vector2(TILE, TILE))
			r = r.intersection(STATION_RECT)
			if r.size.x <= 0 or r.size.y <= 0:
				continue
			_px(r, ZONE_A if (tx + ty) % 2 == 0 else ZONE_B)
	# 破線の枠
	var x := STATION_RECT.position.x
	while x < STATION_RECT.end.x:
		_px(Rect2(x, STATION_RECT.position.y, 10, 2), DARK)
		_px(Rect2(x, STATION_RECT.end.y - 2, 10, 2), DARK)
		x += 20
	var y := STATION_RECT.position.y
	while y < STATION_RECT.end.y:
		_px(Rect2(STATION_RECT.position.x, y, 2, 10), DARK)
		_px(Rect2(STATION_RECT.end.x - 2, y, 2, 10), DARK)
		y += 20


# 夜の静かな雰囲気用に、天井灯の光だまりをうっすら描く(プレイヤーの視認性を保つため淡く)。
func _draw_light_pools() -> void:
	for p in [Vector2(210, 140), Vector2(560, 300), Vector2(900, 250), Vector2(300, 520), Vector2(850, 540)]:
		_ellipse(p, Vector2(150, 90), Color(1, 1, 1, 0.07))
		_ellipse(p, Vector2(90, 54), Color(1, 1, 1, 0.07))
	# 壁際は少し暗くして、奥行きと夜の静けさを出す
	_px(Rect2(32, 32, 1088, 8), Color(0.1, 0.15, 0.25, 0.14))
	_px(Rect2(32, 608, 1088, 8), Color(0.1, 0.15, 0.25, 0.1))


func _draw_wall_shadow(r: Rect2) -> void:
	_px(Rect2(r.position.x, r.end.y, r.size.x, 6), Color(0.1, 0.15, 0.25, 0.18))
	_px(Rect2(r.end.x, r.position.y, 5, r.size.y), Color(0.1, 0.15, 0.25, 0.12))


# 壁:暗い輪郭 + 明るい天面 + 暗い側面で厚みを出し、一定間隔のつなぎ目を入れる。
func _draw_wall(r: Rect2) -> void:
	_px(r, OUTLINE)
	var inner := r.grow(-2)
	_px(inner, WALL_FACE)
	var vertical := r.size.y > r.size.x
	if vertical:
		_px(Rect2(inner.position.x, inner.position.y, 8, inner.size.y), WALL_CAP)
		_px(Rect2(inner.end.x - 6, inner.position.y, 6, inner.size.y), WALL_SIDE)
		var y := r.position.y + 32
		while y < r.end.y - 2:
			_px(Rect2(inner.position.x, y, inner.size.x, 1), WALL_SIDE)
			y += 32
	else:
		_px(Rect2(inner.position.x, inner.position.y, inner.size.x, 8), WALL_CAP)
		_px(Rect2(inner.position.x, inner.end.y - 6, inner.size.x, 6), WALL_SIDE)
		var x := r.position.x + 32
		while x < r.end.x - 2:
			_px(Rect2(x, inner.position.y + 8, 1, inner.size.y - 8), WALL_SIDE)
			x += 32


# ---------- 家具・医療設備 ----------

func _draw_furniture() -> void:
	# 左上エリア(ロッカー・棚・植物)
	_locker(Vector2(48, 38), 4)
	_shelf(Vector2(184, 40), 84)
	_plant(Vector2(350, 70))
	_desk(Rect2(48, 150, 84, 36))
	_chair(Vector2(80, 196))
	_bin(Vector2(346, 330))

	# 上部の病室エリア(ベッド・点滴・モニター・ロッカー)
	_bed(Vector2(440, 44))
	_iv_stand(Vector2(510, 60))
	_monitor_cart(Vector2(526, 100))
	_locker(Vector2(590, 38), 4)
	_bed(Vector2(780, 44))
	_iv_stand(Vector2(850, 60))
	_bed(Vector2(900, 44))
	_monitor_cart(Vector2(960, 96))
	_shelf(Vector2(1000, 40), 84)

	# 中央〜右(机・ワゴン・植物)
	_wagon(Vector2(428, 322))
	_desk(Rect2(960, 270, 92, 36))
	_chair(Vector2(996, 316))
	_plant(Vector2(1086, 372))
	_bin(Vector2(930, 372))

	# 左下エリア(ベッド・点滴・ロッカー・棚)
	_bed(Vector2(64, 512))
	_bed(Vector2(144, 512))
	_iv_stand(Vector2(214, 528))
	_monitor_cart(Vector2(236, 566))
	_desk(Rect2(300, 466, 84, 36))
	_chair(Vector2(332, 510))
	_bin(Vector2(440, 470))
	_locker(Vector2(330, 566), 4)
	_shelf(Vector2(470, 568), 84)
	_plant(Vector2(574, 570))

	# 右下エリア(ベッド・機器・ワゴン・ロッカー)
	_wagon(Vector2(626, 466))
	_desk(Rect2(640, 566, 84, 36))
	_bed(Vector2(1010, 470))
	_iv_stand(Vector2(1080, 490))
	_monitor_cart(Vector2(960, 500))
	_locker(Vector2(820, 568), 4)
	_plant(Vector2(1088, 580))


# ベッド(頭側が上)。フレーム・マットレス・枕・掛け布団・脚。サイズ 48x88。
func _bed(p: Vector2) -> void:
	_px(Rect2(p.x + 2, p.y + 84, 8, 6), OUTLINE)   # 脚
	_px(Rect2(p.x + 38, p.y + 84, 8, 6), OUTLINE)
	_box(Rect2(p.x, p.y, 48, 88), MID, LIGHT, DARK)     # フレーム
	_box(Rect2(p.x, p.y, 48, 8), DARK, MID, OUTLINE)    # ヘッドボード
	_box(Rect2(p.x + 5, p.y + 9, 38, 74), WHITE, WHITE, LIGHT)  # マットレス
	_box(Rect2(p.x + 9, p.y + 12, 30, 14), LIGHT, WHITE, MID)   # 枕
	_box(Rect2(p.x + 5, p.y + 36, 38, 47), BLANKET, WALL_CAP, BLANKET_DARK)  # 掛け布団
	_px(Rect2(p.x + 5, p.y + 36, 38, 4), WHITE)         # 折り返し
	_px(Rect2(p.x + 8, p.y + 54, 32, 1), BLANKET_DARK)


# 点滴スタンド。キャスター付きの脚・支柱・点滴バッグ。
func _iv_stand(p: Vector2) -> void:
	_px(Rect2(p.x - 10, p.y + 40, 22, 3), OUTLINE)   # 脚
	_px(Rect2(p.x - 10, p.y + 43, 4, 3), OUTLINE)    # キャスター
	_px(Rect2(p.x + 8, p.y + 43, 4, 3), OUTLINE)
	_px(Rect2(p.x - 1, p.y, 4, 42), OUTLINE)          # 支柱
	_px(Rect2(p.x, p.y + 2, 2, 38), MID)
	_px(Rect2(p.x - 8, p.y, 18, 3), OUTLINE)          # 横棒
	_box(Rect2(p.x - 9, p.y + 3, 8, 14), WHITE, WHITE, LIGHT)  # バッグ
	_box(Rect2(p.x + 3, p.y + 3, 8, 12), LIGHT, WHITE, MID)
	_px(Rect2(p.x - 6, p.y + 8, 2, 5), SCREEN_LINE)   # 薬液


# モニター付き医療機器台。画面・波形・台・キャスター。
func _monitor_cart(p: Vector2) -> void:
	_px(Rect2(p.x + 2, p.y + 36, 6, 4), OUTLINE)      # キャスター
	_px(Rect2(p.x + 26, p.y + 36, 6, 4), OUTLINE)
	_box(Rect2(p.x, p.y + 20, 34, 18), MID, LIGHT, DARK)  # 本体
	_px(Rect2(p.x + 4, p.y + 28, 12, 2), OUTLINE)     # スロット
	_px(Rect2(p.x + 22, p.y + 26, 6, 6), SCREEN_LINE) # ランプ/ダイヤル
	_box(Rect2(p.x + 3, p.y, 28, 20), DARK, MID, OUTLINE)  # モニター筐体
	_px(Rect2(p.x + 6, p.y + 3, 22, 13), SCREEN)      # 画面
	for i in 5:                                       # 波形
		var dy := -3 if i == 2 else (3 if i == 3 else 0)
		_px(Rect2(p.x + 7 + i * 4, p.y + 9 + dy, 4, 2), SCREEN_LINE)


# ロッカー(n枚扉)。扉の区切り・通気口・取っ手。
func _locker(p: Vector2, n: int) -> void:
	var w := 28.0
	_box(Rect2(p.x, p.y, w * n + 4, 52), DARK, MID, OUTLINE)
	for i in n:
		var d := Rect2(p.x + 2 + i * w, p.y + 2, w, 48)
		_box(d, MID, LIGHT, DARK)
		for j in 3:
			_px(Rect2(d.position.x + 6, d.position.y + 6 + j * 3, w - 12, 1), OUTLINE)
		_px(Rect2(d.end.x - 8, d.position.y + 26, 3, 8), OUTLINE)


# 棚(キャビネット)。段板と、置かれた箱・ファイル。
func _shelf(p: Vector2, w: float) -> void:
	_box(Rect2(p.x, p.y, w, 44), WOOD, LIGHT, WOOD_DARK)
	_px(Rect2(p.x + 3, p.y + 4, w - 6, 16), WOOD_DARK)
	_px(Rect2(p.x + 3, p.y + 24, w - 6, 15), WOOD_DARK)
	var x := p.x + 5
	var i := 0
	while x < p.x + w - 12:
		var c: Color = [WHITE, LIGHT, BLANKET][i % 3]
		_box(Rect2(x, p.y + 8, 8, 12), c, WHITE, MID)
		_box(Rect2(x + 2, p.y + 28, 10, 11), LIGHT, WHITE, MID)
		x += 14
		i += 1
	_px(Rect2(p.x + 2, p.y + 21, w - 4, 3), OUTLINE)


func _desk(r: Rect2) -> void:
	_box(r, WOOD, LIGHT, WOOD_DARK)
	_px(Rect2(r.position.x + 4, r.end.y - 2, 5, 4), OUTLINE)   # 脚
	_px(Rect2(r.end.x - 9, r.end.y - 2, 5, 4), OUTLINE)
	_box(Rect2(r.position.x + 8, r.position.y + 6, 18, 14), WHITE, WHITE, LIGHT)  # 書類
	_px(Rect2(r.position.x + 11, r.position.y + 10, 12, 1), MID)
	_px(Rect2(r.position.x + 11, r.position.y + 13, 12, 1), MID)
	_box(Rect2(r.end.x - 26, r.position.y + 6, 16, 10), DARK, MID, OUTLINE)  # 小型機器


func _chair(p: Vector2) -> void:
	_box(Rect2(p.x - 10, p.y, 20, 8), DARK, MID, OUTLINE)          # 背もたれ
	_box(Rect2(p.x - 9, p.y + 8, 18, 14), MID, LIGHT, DARK)        # 座面
	_px(Rect2(p.x - 1, p.y + 22, 3, 4), OUTLINE)                   # 脚


func _wagon(p: Vector2) -> void:
	_px(Rect2(p.x + 2, p.y + 30, 5, 4), OUTLINE)
	_px(Rect2(p.x + 27, p.y + 30, 5, 4), OUTLINE)
	_box(Rect2(p.x, p.y + 4, 34, 28), LIGHT, WHITE, MID)           # 天板と本体
	_px(Rect2(p.x + 4, p.y + 18, 26, 2), OUTLINE)                  # 引き出し
	_px(Rect2(p.x + 14, p.y + 22, 6, 2), DARK)
	_box(Rect2(p.x + 4, p.y + 7, 10, 8), WHITE, WHITE, MID)        # トレイ上の物
	_box(Rect2(p.x + 20, p.y + 8, 8, 7), BLANKET, WALL_CAP, BLANKET_DARK)
	_px(Rect2(p.x + 32, p.y + 4, 3, 24), OUTLINE)                  # 押し手


func _plant(p: Vector2) -> void:
	_ellipse(p + Vector2(0, 8), Vector2(8, 5), Color(0.1, 0.15, 0.25, 0.2))
	_ellipse(p + Vector2(-6, -4), Vector2(7, 5), OUTLINE)
	_ellipse(p + Vector2(6, -4), Vector2(7, 5), OUTLINE)
	_ellipse(p + Vector2(0, -9), Vector2(6, 6), OUTLINE)
	_ellipse(p + Vector2(-6, -4), Vector2(5, 3), LEAF)
	_ellipse(p + Vector2(6, -4), Vector2(5, 3), LEAF_DARK)
	_ellipse(p + Vector2(0, -9), Vector2(4, 4), LEAF)
	_box(Rect2(p.x - 8, p.y - 1, 16, 14), WOOD, LIGHT, WOOD_DARK)  # 鉢


func _bin(p: Vector2) -> void:
	_box(Rect2(p.x - 9, p.y, 18, 20), MID, LIGHT, DARK)
	_px(Rect2(p.x - 11, p.y - 2, 22, 4), OUTLINE)
	_px(Rect2(p.x - 9, p.y - 1, 18, 2), LIGHT)
	_px(Rect2(p.x - 3, p.y + 6, 1, 10), DARK)
	_px(Rect2(p.x + 3, p.y + 6, 1, 10), DARK)


# ---------- ナースステーション ----------
# 判定エリア(STATION_RECT)の下辺と左辺にカウンターを置く。プレイヤーが立つ中央は空ける。

func _draw_station() -> void:
	var s := STATION_RECT
	# 下のカウンター(横長)
	var bottom := Rect2(s.position.x, s.end.y - 30, s.size.x, 30)
	_box(bottom, LIGHT, WHITE, MID)
	_px(Rect2(bottom.position.x + 2, bottom.position.y + 14, bottom.size.x - 4, 2), MID)   # 天板の縁
	for i in 8:                                                                           # 前面パネル
		_px(Rect2(bottom.position.x + 10 + i * 32, bottom.position.y + 18, 1, 9), MID)
	# 左のカウンター(縦長・L字になる)
	var left := Rect2(s.position.x, s.position.y + 56, 26, s.size.y - 56 - 28)
	_box(left, LIGHT, WHITE, MID)
	_px(Rect2(left.end.x - 6, left.position.y + 2, 2, left.size.y - 4), MID)
	# 天板の上の小物
	_monitor_on_counter(Vector2(s.position.x + 150, bottom.position.y - 18))
	_monitor_on_counter(Vector2(s.position.x + 70, bottom.position.y - 18))
	_box(Rect2(s.position.x + 200, bottom.position.y + 2, 20, 12), WHITE, WHITE, LIGHT)   # 書類
	_box(Rect2(s.position.x + 226, bottom.position.y + 2, 14, 10), BLANKET, WALL_CAP, BLANKET_DARK)  # ファイル
	_box(Rect2(left.position.x + 3, left.position.y + 8, 14, 18), WHITE, WHITE, LIGHT)
	_box(Rect2(left.position.x + 5, left.position.y + 40, 12, 10), DARK, MID, OUTLINE)    # 電話
	# 受付の表示板(十字マーク)
	var sign_r := Rect2(s.position.x + 30, s.position.y - 26, 40, 22)
	_box(sign_r, WHITE, WHITE, LIGHT)
	_px(Rect2(sign_r.position.x + 18, sign_r.position.y + 5, 4, 12), SCREEN_LINE)
	_px(Rect2(sign_r.position.x + 14, sign_r.position.y + 9, 12, 4), SCREEN_LINE)
	# カウンターの内側の椅子
	_chair(Vector2(s.position.x + 110, s.end.y - 62))


func _monitor_on_counter(p: Vector2) -> void:
	_box(Rect2(p.x, p.y, 28, 18), DARK, MID, OUTLINE)
	_px(Rect2(p.x + 3, p.y + 3, 22, 10), SCREEN)
	_px(Rect2(p.x + 5, p.y + 8, 5, 2), SCREEN_LINE)
	_px(Rect2(p.x + 11, p.y + 6, 5, 2), SCREEN_LINE)
	_px(Rect2(p.x + 17, p.y + 9, 6, 2), SCREEN_LINE)
	_px(Rect2(p.x + 11, p.y + 18, 6, 3), OUTLINE)
