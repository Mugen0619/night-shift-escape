extends Node
## 最小限の効果音を鳴らす。Autoload(project.godot に登録)として常に1つだけ存在する。
## 音声ファイルは使わず、起動時にコードで短い音(サイン波)を生成する(外部素材・ライセンス不要)。
## 音が鳴らなくてもゲームの進行には影響しない。

const MIX_RATE := 22050
const VOLUME := 0.25  # 振幅(0〜1)。控えめにして、プレイを邪魔しない。

var _player: AudioStreamPlayer
var _item: AudioStreamWAV
var _clear: AudioStreamWAV
var _game_over: AudioStreamWAV
var _restart: AudioStreamWAV


func _ready() -> void:
	_player = AudioStreamPlayer.new()
	add_child(_player)
	# [周波数Hz, 長さ秒] を順に鳴らす。
	_item = _make_stream([[880.0, 0.06], [1320.0, 0.09]])
	_clear = _make_stream([[523.0, 0.12], [659.0, 0.12], [784.0, 0.12], [1047.0, 0.3]])
	_game_over = _make_stream([[392.0, 0.18], [330.0, 0.18], [262.0, 0.4]])
	_restart = _make_stream([[660.0, 0.07]])


func play_item() -> void:
	_play(_item)


func play_clear() -> void:
	_play(_clear)


func play_game_over() -> void:
	_play(_game_over)


func play_restart() -> void:
	_play(_restart)


func _play(stream: AudioStreamWAV) -> void:
	_player.stream = stream
	_player.play()


# 音の並びから、16bit モノラルの AudioStreamWAV を作る。各音は末尾に向けて小さくなる。
func _make_stream(notes: Array) -> AudioStreamWAV:
	var data := PackedByteArray()
	for note in notes:
		var freq: float = note[0]
		var count := int(MIX_RATE * float(note[1]))
		for i in count:
			var envelope := 1.0 - float(i) / count
			var sample := sin(TAU * freq * i / MIX_RATE) * envelope * VOLUME
			var value := int(sample * 32767.0)
			data.append(value & 0xFF)
			data.append((value >> 8) & 0xFF)
	var stream := AudioStreamWAV.new()
	stream.format = AudioStreamWAV.FORMAT_16_BITS
	stream.mix_rate = MIX_RATE
	stream.data = data
	return stream
