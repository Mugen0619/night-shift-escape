extends Label
## 残り時間を「TIME MM:SS」形式で表示する。
## 時間そのものは Time ノード(Timer)が管理し、このスクリプトは読んで表示するだけ。

# 表示する残り時間を持つ Timer(main.tscn で Time ノードを指定する)。
@export var time: Timer


func _process(_delta: float) -> void:
	text = "TIME " + format_time(time.time_left)


# 秒数を「MM:SS」(分・秒とも2桁の0埋め)の文字列にする。
# 小数点以下は切り上げる。残り0.3秒のときに「00:00」と表示すると時間切れと誤解されるため、
# 「00:00」になるのは本当に0秒になったときだけにする。
static func format_time(seconds: float) -> String:
	var total: int = ceili(maxf(seconds, 0.0))
	var minutes: int = floori(total / 60.0)
	var secs: int = total % 60
	return "%02d:%02d" % [minutes, secs]
