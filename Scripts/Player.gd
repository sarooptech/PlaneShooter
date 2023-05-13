extends Area2D

@export var speed : float = 500
@export var health : float = 10
@export var damage_prefab : PackedScene  = null
@export var blast_effect_prefab : PackedScene  = null
@export var game_ui: Node = null
@export var coin_sound : AudioStream
@export var power_up_sound : AudioStream
@export var damage_sound : AudioStream

@onready var audio_player : AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var starting_health = health

var bar_size : float = 1 
var damage : float = 0 

var min_x : float = 0
var max_x : float = 0
var min_y : float = 0
var max_y : float = 0

var padding : float = 100

var clicked : bool = false

func _ready() -> void:
	find_bounds()
	
	damage = bar_size /  health
	
	connect("area_entered", Callable(self, "_on_area_entered"))

func _process(delta: float) -> void:
	# Movement Logic
	var pos = self.position
	if Input.is_action_pressed("ui_right"):
		pos.x += speed * delta
	elif Input.is_action_pressed("ui_left"):
		pos.x -= speed * delta
	
	if Input.is_action_pressed("ui_up"):
		pos.y -= speed * delta
	elif Input.is_action_pressed("ui_down"):
		pos.y += speed * delta
	
	pos.x = clamp(pos.x, min_x, max_x)
	pos.y = clamp(pos.y, min_y, max_y)
	
	self.position = pos

func _unhandled_input(event) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			clicked = event.pressed
	if event is InputEventMouseMotion:
		if clicked:
			var pos = self.position + event.relative
			pos.x = clamp(pos.x, min_x, max_x)
			pos.y = clamp(pos.y, min_y, max_y)
			self.position = pos

func find_bounds() -> void:
	var size = get_viewport_rect().size
	var window_width = ProjectSettings.get_setting("display/window/size/viewport_width")
	var window_height = ProjectSettings.get_setting("display/window/size/viewport_height")
	var window_size = Vector2(window_width, window_height)
	
	var diff = (size - window_size)/2
	
	min_x = -diff.x + padding
	max_x = size.x - diff.x - padding
	
	min_y = -diff.y + padding
	max_y = size.y - diff.y - padding

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("EnemyBullet"):
		audio_player.stream = damage_sound
		audio_player.play()
		var damage_effect = damage_prefab.instantiate()
		damage_effect.position = area.position
		area.get_parent().add_child(damage_effect)
		
		area.queue_free()
		
		damage_health_bar()
		
		if health <= 0:
			var blast_effect = blast_effect_prefab.instantiate()
			blast_effect.position = self.position
			get_parent().add_child(blast_effect)
			game_ui.game_over()
			self.queue_free()
		
	elif area.is_in_group("Coin"):
		audio_player.stream = coin_sound
		audio_player.play()
		area.queue_free()
		if game_ui != null:
			game_ui.add_coin()
		
	elif area.is_in_group("PowerUp"):
		audio_player.stream = power_up_sound
		audio_player.play()
		area.queue_free()
		refill_health_bar()


func refill_health_bar() -> void:
	health = starting_health
	bar_size = 1
	game_ui.set_player_health(bar_size)

func damage_health_bar() -> void:
	if health > 0:
		health -= 1
		bar_size -= damage
		game_ui.set_player_health(bar_size)
