class_name Dash
extends Panel

@onready var car: Vehicle = get_parent()

func _physics_process(delta):
	rotation_degrees = -car.global_rotation_degrees
	global_position = car.global_position + Vector2(10, -23)


func set_speed(s: float):
	$Speed.text = "%d" % s


func set_factor(f: float):
	$Factor.text = "%0.1f" % f
