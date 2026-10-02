extends Area2D
## マップ上のアイテム。プレイヤーが触れると GameManager に取得を伝えて消える。
## 3種類とも同じシーン(item.tscn)を使い、item_type だけを変えて配置する。

# 仮の見た目として、種類ごとに色を分ける(画像素材はまだ使わない)。
const COLORS: Dictionary = {
	"key": Color(1.0, 0.85, 0.2),         # 鍵: 黄色
	"chart": Color(0.95, 0.95, 0.95),     # カルテ: 白
	"flashlight": Color(1.0, 0.5, 0.1),   # 懐中電灯: オレンジ
}

# インスペクターで選べるようにする(main.tscn で配置ごとに設定)。
@export_enum("key", "chart", "flashlight") var item_type: String = "key"


func _ready() -> void:
	$ColorRect.color = COLORS[item_type]
	# Area2D は「重なった」ことを検知するだけで、プレイヤーの移動は妨げない。
	body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node2D) -> void:
	# 壁など、プレイヤー以外の物体には反応しない。
	if not body.is_in_group("player"):
		return
	GameManager.collect_item(item_type)
	# ノードごと削除するので、同じアイテムをもう一度取得することはない。
	queue_free()
func broken(:
