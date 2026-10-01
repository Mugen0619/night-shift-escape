extends CharacterBody2D
## プレイヤー。キーボード入力で上下左右に移動し、壁(StaticBody2D)に当たると止まる。

# 移動速度(ピクセル/秒)
const SPEED: float = 200.0


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
