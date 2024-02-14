class_name TrafficLight 
extends Sprite2D

signal light_changed(the_light)

var is_green: bool


func toggle_light():
	if is_green:
		self_modulate = Color.RED
	else:
		self_modulate = Color.GREEN
	
	is_green = !is_green
	#print("%d - Emitting %s" % [Time.get_ticks_msec(), self])
	light_changed.emit(self)


func _to_string() -> String:
	var base_response = "<%s#%s>" % [get_class(), get_instance_id()]
	return base_response + (" -> GREEN" if is_green else " -> RED")
