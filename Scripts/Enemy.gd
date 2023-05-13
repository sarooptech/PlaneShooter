extends Area2D

@export var speed : float = 100
@export var health : float = 10
@export var damage_prefab : PackedScene  = null
@export var explosion_prefab : PackedScene  = null
@export var damage_sound : AudioStreamWAV

@onready var health_bar : Node2D = $HealthBar
@onready var audio_player : AudioStreamPlayer2D = AudioStreamPlayer2D.new()

var bar_size : float = 1
var damage : float = 0
var min_x : float = 0
var max_x : float = 0
var min_y : float = 0
var max_y : float = 0
var padding : float = 100

func _ready() -> void:
	self.add_child(audio_player)
	
	connect("area_entered", Callable(self, "_on_area_entered"))
	
	damage = bar_size /  health

func _process(delta: float) -> void:
	self.position.y += speed * delta

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("Bullet"):
		
		audio_player.stream = damage_sound
		audio_player.play()
		
		var damage_effect = damage_prefab.instantiate()
		damage_effect.position = area.position
		area.get_parent().add_child(damage_effect)
		
		area.queue_free()
		
		damage_health_bar()
		
		if health <= 0:
			var explosion = explosion_prefab.instantiate()
			explosion.position = self.position
			get_parent().add_child(explosion)
			
			self.queue_free()

func damage_health_bar() -> void:
	if health > 0:
		health -= 1
		bar_size -= damage
		health_bar.set_size(bar_size)
