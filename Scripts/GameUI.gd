extends CanvasLayer

@onready var coin_count_label : Label = $HUD/CoinCounter/Label
@onready var player_health : ProgressBar = $HUD/PlayerHealth
@onready var game_over_screen : Panel = $GameOver
@onready var game_complete_screen : Panel = $GameComplete
@onready var gc_coin_count_label : Label = $GameComplete/CoinCounter/Label
@onready var pause_screen : Panel = $Pause
@onready var start_screen: Panel = $StartScreen

var count : int = 0
var last_enemy_spawned = false

func _ready() -> void:
	coin_count_label.text = "COINS:" + str(count)
	player_health.value = 1
	
	if !GM.game_started:
		start_screen.show()
		get_tree().paused = true
	else:
		start_screen.hide()
		get_tree().paused = false

func add_coin() -> void:
	count += 1
	coin_count_label.text = "COINS:" + str(count)

func set_player_health(value:float) -> void:
	player_health.value = value

func game_over() -> void:
	get_tree().paused = true
	game_over_screen.show()

func game_complete() -> void:
	get_tree().paused = true
	gc_coin_count_label.text = coin_count_label.text
	game_complete_screen.show()

func reload_scene() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()

func exit_game() -> void:
	get_tree().quit()

func pause_game() -> void:
	get_tree().paused = true
	pause_screen.show()

func resume_game() -> void:
	get_tree().paused = false
	pause_screen.hide()
	if start_screen.is_visible_in_tree():
		start_screen.hide()
	GM.game_started = true

func next_level() -> void:
	GM.next_level()
	get_tree().paused = false
	get_tree().reload_current_scene()
