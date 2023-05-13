extends Resource

class_name Level

@export_range(1.0, 5.0) var enemy_spawn_time : float = 3
@export_range(1, 100) var enemy_count : int = 5
@export var enemy_prefabs : Array[PackedScene]
