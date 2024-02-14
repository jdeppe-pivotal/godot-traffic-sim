extends CheckButton


func _on_toggled(toggled_on: bool):
	var level: Level = find_parent("GameManager").find_child("Level", true, false)
	level._on_auto_lights_toggled(toggled_on)
