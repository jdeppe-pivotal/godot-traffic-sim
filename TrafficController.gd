class_name TrafficController
extends Node2D

var lights: Array[TrafficLight]
var frequency: float = 5.0
var timer: SceneTreeTimer

var main: Level

func _ready():
	var found_lights = find_children("TrafficLight*")
	
	lights.resize(found_lights.size())
	for i in range(found_lights.size()):
		lights[i] = found_lights[i] as TrafficLight
		
	lights[0].is_green = true
	lights[1].is_green = false
	call_deferred("change_lights")

	main = find_parent("Level")
	main.auto_lights.connect(_on_auto_lights_toggle)


func change_lights():
	lights[0].toggle_light()
	lights[1].toggle_light()
	if main.is_auto_lights():
		timer = get_tree().create_timer(frequency)
		timer.timeout.connect(change_lights)

	
func _on_manual_switch_gui_input(event):
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) && !main.is_auto_lights():
		#print("EVENT %s" % event) # Replace with function body.
		change_lights()


func _on_auto_lights_toggle(toggled_on: bool):
	if !toggled_on && timer.timeout.is_connected(change_lights):
		timer.timeout.disconnect(change_lights)
	else:
		timer = get_tree().create_timer(frequency)
		timer.timeout.connect(change_lights)

