extends Node2D

@onready var start_1: Marker2D = %Start1
@onready var start_2: Marker2D = %Start2
@onready var button: Button = %Button
@onready var time: Label = %Time

@export var respawn_timeout_sec = .5

const SHIP = preload("uid://dbh4xmvkqc7uv")

func _ready() -> void:
	_spawn(1)
	_spawn(2)
	button.grab_focus()
	time.text = _to_duration(General.finish_time)

func _on_ship_death(ship: Ship):
	var player = ship.player
	ship.queue_free()
	await get_tree().create_timer(respawn_timeout_sec).timeout
	_spawn(player)

func _spawn(player: int):
	var ship: Ship = SHIP.instantiate()
	ship.start_position = start_1.position if player == 1 else start_2.position
	ship.player = player
	ship.position = ship.start_position
	add_child(ship)
	ship.on_death.connect(_on_ship_death.bind(ship))

func _on_button_pressed() -> void:
	SceneTransition.change_scene("res://scenes/menus/main/MainMenu.tscn")

func _to_duration(ms: int) -> String:
	var minutes = ms / (1000*60)
	var seconds = (ms - minutes*1000*60) / 1000
	var millis = ms- minutes*1000*60 - seconds*1000
	
	return "%02d:%02d.%03d" % [minutes, seconds, millis]
