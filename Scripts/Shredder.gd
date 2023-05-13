extends Area2D

func _ready() -> void:
	connect("area_entered", Callable(self, "_area2d_entered"))

func _area2d_entered(area: Area2D) -> void:
	area.queue_free()
