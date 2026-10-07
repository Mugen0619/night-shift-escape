extends Label
## 残り時間を「TIME MM:SS」形式で表示する。
## 時間そのものは Time ノード(Timer)が管理し、このスクリプトは読んで表示するだけ。

# 表示する残り時間を持つ Timer(main.tscn で Time ノードを指定する)。
@export var time: Timer

# 残りがこの秒数以下になったら文字を赤くして、時間が少ないことを知らせる。
const WARNING_SECONDS: float = 30.0
const NORMAL_COLOR: Color = Color(1, 1, 1)
const WARNING_COLOR: Color = Color(1, 0.35, 0.35)


func _process(_delta: float) -> void:
	text = "TIME " + format_time(time.time_left)
	var is_warning: bool = time.time_left <= WARNING_SECONDS
	add_theme_color_override("font_color", WARNING_COLOR if is_warning else NORMAL_COLOR)


# 秒数を「MM:SS」(分・秒とも2桁の0埋め)の文字列にする。
# 小数点以下は切り上げる。残り0.3秒のときに「00:00」と表示すると時間切れと誤解されるため、
# 「00:00」になるのは本当に0秒になったときだけにする。
static func format_time(seconds: float) -> String:
	var total: int = ceili(maxf(seconds, 0.0))
	var minutes: int = floori(total / 60.0)
	var secs: int = total % 60
	return "%02d:%02d" % [minutes, secs]
