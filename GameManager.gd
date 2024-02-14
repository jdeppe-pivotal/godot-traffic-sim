extends Node
class_name GameManager

signal toggle_game_paused(is_paused: bool)
signal signal_game_over()

@onready var level1_scene: PackedScene = load("res://level1.tscn")

var current_level: Node
var game_paused: bool = false:
	get:
		return game_paused
	set(value):
		game_paused = value
		get_tree().paused = game_paused
		if !is_game_over:
			emit_signal("toggle_game_paused", value)

var is_game_over: bool = false


func _input(event : InputEvent):
	if event.is_action_pressed("ui_cancel"):
		game_paused = !game_paused


func game_over():
	is_game_over = true
	game_paused = true
	emit_signal("signal_game_over")


func quit_game():
	get_tree().quit()


func new_game():
	if current_level:
		# This allows the level we're about to re-add to still be named 'Level'. Otherwise it will
		# get a generated name and we need to be able to find a 'Level' node elsewhere in the game.
		current_level.name = "DeletedLevel"
		current_level.queue_free()
		
	current_level = level1_scene.instantiate()
	add_child(current_level)
	game_paused = false
	is_game_over = false
