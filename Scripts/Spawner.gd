extends Node2D

@onready var timer : Timer = Timer.new()

@export var level_data : Level
@export var game_ui : Node

var enemies : Array[Area2D]
var last_enemy_spawned : bool = false

func _ready() -> void:
	load_level_data()
	randomize()
	timer.wait_time = level_data.enemy_spawn_time
	timer.autostart = true
	self.add_child(timer)
	
	timer.connect("timeout", Callable(self, "spawn"))

func load_level_data() -> void:
	level_data = load("res://Levels/level_"+ str(GM.current_level) + ".tres");

func _process(_delta: float) -> void:
	if (!last_enemy_spawned):
		return
	
	if (enemies.size() == 0):
		return
		
	for enemy in enemies:
		if enemy != null:
			return
	
	if get_node("%Player") != null:
		game_ui.game_complete()
	else:
		game_ui.game_over()

func spawn() -> void:
	if level_data.enemy_prefabs.size() == 0:
		return
	
	var random_enemy : int = randi() % level_data.enemy_prefabs.size()
	
	var enemy : Area2D = level_data.enemy_prefabs[random_enemy].instantiate()
	enemy.position = self.position
	enemy.position.x += randf_range(-260, 260)
	self.get_parent().add_child(enemy)
	
	enemies.push_back(enemy)
	
	level_data.enemy_count -= 1
	
	if level_data.enemy_count <= 0:
		timer.disconnect("timeout", Callable(self, "spawn"))
		last_enemy_spawned = true
