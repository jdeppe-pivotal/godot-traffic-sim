extends RayCast2D

var disable_delay_time: float = 0.5

@onready var car: Vehicle = get_parent()

var waiting_for_light: bool = false

func _physics_process(delta):
	if ! is_colliding():
		return
		
	var light = get_collider().get_parent()
	if ! light is TrafficLight || light.is_green:
		return

	car.stop_for_light(car.global_position.distance_to(get_collision_point()))

	if waiting_for_light:
		return

	call_deferred("connect_light", light)


func connect_light(light: TrafficLight):
	waiting_for_light = true
	light.connect("light_changed", light_changed_callback)
	#print("%d - Connected light %s  %s" % [Time.get_ticks_msec(), car, light])


func light_changed_callback(the_light: TrafficLight):
	#print("%d - Disconnecting changed light %s  %s" % [Time.get_ticks_msec(), car, the_light])
	the_light.disconnect("light_changed", light_changed_callback)
	waiting_for_light = false
	if the_light.is_green:
		car.stop_for_light(INF)

