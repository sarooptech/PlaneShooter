extends Node2D

@export var speed : int = -2

func _process(delta: float) -> void:
	self.position.y += speed * 100 * delta
