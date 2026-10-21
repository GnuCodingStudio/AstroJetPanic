extends Node2D

@onready var start_1: Marker2D = %Start1
@onready var start_2: Marker2D = %Start2
@onready var explosion: AudioStreamPlayer = %ExplosionPlayer
@onready var victory: AudioStreamPlayer = %VictoryPlayer
@onready var time: GameTime = %Time

@export var respawn_timeout_sec = .5

const SHIP = preload("uid://dbh4xmvkqc7uv")


func _ready() -> void:
	_spawn(1)
	if General.players_count == 2:
		_spawn(2)

func _on_ship_death(ship: Ship):
	explosion.play()
	var player = ship.player
	ship.queue_free()
	await get_tree().create_timer(respawn_timeout_sec).timeout
	_spawn(player)
	
	if General.players_count == 1:
		_reset_timer()

func _spawn(player: int):
	var ship: Ship = SHIP.instantiate()
	ship.start_position = start_1.position if player == 1 else start_2.position
	ship.player = player
	ship.position = ship.start_position
	add_child(ship)
	ship.on_death.connect(_on_ship_death.bind(ship))

func _on_end_area_body_entered(body: Node2D) -> void:
	if body is Ship:
		time.stop()
		victory.play()
		body.win()
		for child in get_children():
			if child != body and child is Ship:
				child.loose()
		await get_tree().create_timer(1.5).timeout
		SceneTransition.change_scene("res://scenes/menus/Victory.tscn")

func _reset_timer():
	time.reset()
