extends CharacterBody2D
## プレイヤー。キーボード入力で上下左右に移動し、壁(StaticBody2D)に当たると止まる。

# 移動速度(ピクセル/秒)
const SPEED: float = 200.0

# 見た目(当たり判定 32x32 の範囲に収まる、看護師風の人物)
const OUTLINE := Color("26303c")
const UNIFORM := Color(0.3, 0.6, 1.0)
const UNIFORM_DARK := Color(0.2, 0.42, 0.78)
const SKIN := Color(1.0, 0.85, 0.72)
const HAIR := Color(0.25, 0.18, 0.15)
const WHITE := Color(0.97, 0.98, 1.0)


func _draw() -> void:
	# 足元の影(床の上でプレイヤーを目立たせる)
	draw_set_transform(Vector2(0, 14), 0.0, Vector2(1.0, 0.35))
	draw_circle(Vector2.ZERO, 15.0, Color(0.1, 0.15, 0.25, 0.25))
	draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
	# 体
	draw_rect(Rect2(-15, -6, 30, 22), OUTLINE)
	draw_rect(Rect2(-13, -4, 26, 18), UNIFORM)
	draw_rect(Rect2(-13, 9, 26, 5), UNIFORM_DARK)
	draw_rect(Rect2(-2, -4, 4, 18), WHITE)
	# 頭
	draw_circle(Vector2(0, -7), 11.0, OUTLINE)
	draw_circle(Vector2(0, -7), 9.0, SKIN)
	draw_rect(Rect2(-9, -16, 18, 6), HAIR)
	# ナースキャップ(白地に赤い印)
	draw_rect(Rect2(-7, -17, 14, 5), OUTLINE)
	draw_rect(Rect2(-6, -16, 12, 3), WHITE)
	draw_rect(Rect2(-1, -16, 2, 3), Color(0.9, 0.2, 0.25))
	# 目
	draw_rect(Rect2(-5, -6, 2, 3), OUTLINE)
	draw_rect(Rect2(3, -6, 2, 3), OUTLINE)


# 移動と衝突は物理エンジンと同じタイミングで処理するため、
# _process ではなく _physics_process を使う。
func _physics_process(_delta: float) -> void:
	# 入力アクション(project.godot の Input Map で定義)から移動方向を作る。
	# get_vector は斜め入力の長さを1に正規化するため、斜め移動でも速くならない。
	var direction: Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * SPEED

	# move_and_slide は velocity に従って移動し、壁にぶつかったらそこで止める。
	# 壁に斜めに当たった場合は、壁に沿う方向の成分だけ動き続ける(壁沿いに滑る)。
	# delta(経過時間)は move_and_slide の内部で掛けられるので、ここでは掛けない。
	move_and_slide()
