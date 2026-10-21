class_name GameTime extends Label

var start: int
var finished: bool = false

func _ready() -> void:
	reset()

func _process(delta: float) -> void:
	if not finished:
		var ms = Time.get_ticks_msec() - start
		text = _to_duration(ms)

func stop() -> void:
	finished = true
	var finish_time = Time.get_ticks_msec() - start
	text = _to_duration(finish_time)
	General.finish_time = finish_time

func reset() -> void:
	start = Time.get_ticks_msec()
	finished = false

func _to_duration(ms: int) -> String:
	var minutes = ms / (1000*60)
	var seconds = (ms - minutes*1000*60) / 1000
	var millis = ms- minutes*1000*60 - seconds*1000
	
	return "%02d:%02d.%03d" % [minutes, seconds, millis]
