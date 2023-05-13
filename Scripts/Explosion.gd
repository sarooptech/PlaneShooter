extends Node2D

@export var coin_prefab : PackedScene
@export var power_up_prefab : PackedScene

func _ready() -> void:
	randomize()

func add_coin() -> void:
	
	if (randi() % 5) == 0:
		var power_up = power_up_prefab.instantiate()
		power_up.position = self.position
		get_parent().add_child(power_up)
		
	else:
		var coin = coin_prefab.instantiate()
		coin.position = self.position
		get_parent().add_child(coin)
	
	self.queue_free()
