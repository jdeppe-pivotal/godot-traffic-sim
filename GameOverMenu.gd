extends Control

@export var game_manager : GameManager

func _ready():
	hide()
	game_manager.connect("signal_game_over", _on_game_manager_signal_game_over)


func _on_game_manager_signal_game_over():
	show()


func _on_play_again_label_pressed():
	hide()
	game_manager.new_game()


func _on_quit_label_pressed():
	game_manager.quit_game()
