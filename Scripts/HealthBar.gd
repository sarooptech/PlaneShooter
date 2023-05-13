extends Node2D

@onready var bar : Node2D = $Bar

func _ready() -> void:
	set_size(1)

func set_size(size: float) -> void:
	bar.scale.x = size
