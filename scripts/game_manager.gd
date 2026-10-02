extends Node
## ゲーム全体で共有する状態を持つ。Autoload(project.godot に登録)として常に1つだけ存在する。
## Day 2 時点では、3つのアイテムを取得したかどうかだけを管理する。

var has_key: bool = false
var has_chart: bool = false
var has_flashlight: bool = false


# アイテムを取得済みにする。item_type は item.gd の item_type と同じ文字列。
func collect_item(item_type: String) -> void:
	match item_type:
		"key":
			has_key = true
		"chart":
			has_chart = true
		"flashlight":
			has_flashlight = true
		_:
			# 想定外の名前は、タイプミスにすぐ気付けるようにエラーとして出す。
			push_error("未知のアイテム種類: %s" % item_type)


# 取得済みのアイテム数(0〜3)を返す。
# 数は保存せず、3つの状態から毎回数える(状態の持ち方を増やさないため)。
func get_collected_count() -> int:
	return int(has_key) + int(has_chart) + int(has_flashlight)
