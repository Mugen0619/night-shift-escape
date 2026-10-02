extends Label
## 取得済みのアイテム数を「ITEM n/3」形式で表示する。
## 数は GameManager から読むだけで、このスクリプトは状態を持たない。

# 集めるアイテムの総数(鍵・カルテ・懐中電灯)
const TOTAL_ITEMS: int = 3


func _process(_delta: float) -> void:
	text = "ITEM %d/%d" % [GameManager.get_collected_count(), TOTAL_ITEMS]
