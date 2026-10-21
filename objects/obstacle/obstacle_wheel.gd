extends StaticBody2D

@export var rotation_speed: float = 4
@export var clockwise: bool = true


func _process(delta: float) -> void:
	rotation = rotation + (rotation_speed * delta * (1 if clockwise else -1))
