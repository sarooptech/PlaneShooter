extends Sprite2D

@export var speed : float = 100

func _process(delta: float) -> void:
	region_rect.position.y -= speed * delta
