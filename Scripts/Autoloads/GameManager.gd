extends Node

var current_level = 1
var game_started = false

func next_level() -> void:
	current_level += 1
	if (current_level > 2):
		current_level = 1
