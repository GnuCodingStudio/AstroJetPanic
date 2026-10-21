class_name Ship extends RigidBody2D

@export var thrust: float = 300.0
@export var max_speed: float = 600.0
@export var rotation_speed: float = 7.0

@onready var ship_sprite: Sprite2D = %ShipSprite
@onready var burst_sprite: Sprite2D = %BurstSprite

var _burst_key: String
var _left_key: String
var _right_key: String

var player: int
var start_position: Vector2
var engine: bool = true

signal on_death

func _ready() -> void:
	if player == 1:
		_burst_key = "burst-ship-1"
		_left_key = "turn-left-ship-1"
		_right_key ="turn-right-ship-1"
		ship_sprite.modulate = Color("#D94FBA")
		collision_layer = 1
		collision_mask |= 2
	else:
		_burst_key = "burst-ship-2"
		_left_key = "turn-left-ship-2"
		_right_key ="turn-right-ship-2"
		ship_sprite.modulate = Color("#68CEF6")
		collision_layer = 2
		collision_mask |= 1

func _process(_delta: float) -> void:
	burst_sprite.visible = Input.is_action_pressed(_burst_key)

func win():
	engine = false

func loose():
	engine = false

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	if not engine: return
	
	var turn := Input.get_axis(_left_key, _right_key)
	state.angular_velocity = turn * rotation_speed

	if Input.is_action_pressed(_burst_key):
		var forward := Vector2.UP.rotated(state.transform.get_rotation())
		state.apply_central_force(forward * thrust)

	if state.linear_velocity.length() > max_speed:
		state.linear_velocity = state.linear_velocity.normalized() * max_speed

func _on_body_entered(body: Node) -> void:
	if engine and body is not Ship:
		on_death.emit()
