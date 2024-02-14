extends Control

@export var game_manager: GameManager


func _on_start_button_pressed():
	hide()
	game_manager.new_game()
