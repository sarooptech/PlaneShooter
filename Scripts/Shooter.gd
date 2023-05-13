extends Node

@onready var parent : Node2D = get_parent()
@onready var timer : Timer = Timer.new()
@onready var flash_timer : Timer = Timer.new()
@onready var audio_player : AudioStreamPlayer2D = AudioStreamPlayer2D.new()

@export var is_enemy : bool = true
@export var bullet_prefab : PackedScene = null 
@export var auto_shoot_delay : float = 0.2
@export var gun_flash : Node2D
@export var bullet_sound : AudioStream

var bullet_points : Array = []

func _ready() -> void:
	find_bullet_points()
	
	hide_flash()
	
	audio_player.stream = bullet_sound
	self.add_child(audio_player, true)
	
	
	self.add_child(timer, true)
	timer.wait_time = auto_shoot_delay
	timer.connect("timeout", Callable(self, "fire"))
	
	self.add_child(flash_timer, true)
	flash_timer.wait_time = 0.1
	flash_timer.connect("timeout", Callable(self, "hide_flash"))
	
	if is_enemy:
		timer.start()

func _process(_delta: float) -> void:
	if is_enemy:
		return
	if Input.is_action_just_pressed("ui_accept"):
		if timer.is_stopped():
			fire()
			timer.start()
	
	if Input.is_action_just_released("ui_accept"):
		timer.stop()
	
	if Input.is_action_just_pressed("click"):
		if timer.is_stopped():
			fire()
			timer.start()
	
	if Input.is_action_just_released("click"):
		timer.stop()

func find_bullet_points() -> void:
	var children = self.get_children()
	
	if children.size() == 0:
		return
	
	for child in children:
		if child is Marker2D:
			bullet_points.append(child.position)

func fire() -> void:
	if bullet_prefab == null or bullet_points.size() == 0:
		return
	
	show_flash()
	
	audio_player.play()
	
	for point in bullet_points:
		var bullet : Area2D = bullet_prefab.instantiate()
		bullet.position = parent.position + point
		parent.get_parent().add_child(bullet)

func show_flash() -> void:
	if gun_flash == null:
		return
	
	gun_flash.visible = true
	flash_timer.start()

func hide_flash() -> void:
	if gun_flash == null:
		return
	gun_flash.visible = false
