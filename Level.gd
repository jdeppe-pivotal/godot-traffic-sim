extends Node2D
class_name Level

var score: float = 0.0

@export var time: float = 30.0

@onready var game_manager: GameManager = get_node("/root/GameManager")
@onready var autoLights: CheckButton = find_child("AutoLights")
@onready var scoreText: Label = find_child("Score")
@onready var timeText: Label = find_child("Time")

signal auto_lights(toggled_on)


func _process(delta):
	time -= delta
	if time < 0.0:
		time = 0.0
	timeText.text = "%0.1f" % time

	if time == 0.0:
		game_manager.game_over()


func add_score(delta: float):
	score += delta
	scoreText.text = "%d" % score


func is_auto_lights() -> bool:
	return autoLights.button_pressed


func _on_auto_lights_toggled(toggled_on):
	auto_lights.emit(toggled_on)
