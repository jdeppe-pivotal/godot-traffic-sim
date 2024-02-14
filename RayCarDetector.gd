extends RayCast2D

@onready var car: Vehicle = get_parent()


func _physics_process(delta):
	if is_colliding():
		var distance: float = global_position.distance_to(get_collision_point())
		car.slow_down_for_car(distance)
	else:
		car.slow_down_for_car(INF)
