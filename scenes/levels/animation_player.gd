extends AnimationPlayer

@export var delay: float

func _ready() -> void:
	await get_tree().create_timer(delay).timeout
	self.play("move")
