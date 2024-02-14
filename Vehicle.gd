class_name Vehicle
extends CharacterBody2D

var max_speed: float
var prepared_max_speed: float
var movement_speed: float = 100.0
var target_position: Vector2
var follow_path: PathFollow2D
var next_areas: Array[Area2D] = []
var speed: float
var distance_to_car: float = INF
var distance_to_light: float = INF
var stall_time: float = 0.0

@onready var car_length: float = $CarBody/BodyCollider.shape.size.x
@onready var dash: Dash = $Dash
@onready var main: Level = find_parent("Level")
@onready var animation: AnimationPlayer = $TurningRedAnimation
@onready var explosion: PackedScene = preload("res://car_explosion.tscn")


func _ready():
	target_position = position + Vector2(100, 0)
	speed = max_speed


func _physics_process(delta):
	var min_distance = minf(distance_to_car, distance_to_light)
	if min_distance == INF:
		speed += 5
	else:
		var factor = speed / (min_distance - car_length)
		speed -= factor
		if speed > 1.0 and speed < 5.0:
			speed = 5.0
		elif speed <= 1.0:
			speed = 0

	speed = clamp(speed, 0, max_speed)
	dash.set_speed(speed)
	dash.set_factor(min_distance)
	
	if speed == 0.0:
		if stall_time == 0.0:
			animation.play("fade_to_red")
		stall_time += delta
		if stall_time > 7.0:
			car_stalled_too_long()
		main.add_score(-1.0)
	else:
		animation.stop(false)
		stall_time = 0.0
		main.add_score(speed * delta)
	
	if follow_path:
		follow_path.set_progress(follow_path.get_progress() + speed * delta)
		if follow_path.progress_ratio < 1.0:
			return
	else:
		position = position.lerp(target_position, delta * 1.0)
		return

	if ! next_areas.is_empty():
		call_deferred("_assign_next_path")


func car_stalled_too_long():
	main.add_score(-1000)
	get_parent().add_child(explosion.instantiate())
	queue_free()


func stop_for_light(distance: float):
	distance_to_light = distance


func slow_down_for_car(distance: float):
	distance_to_car = distance


func _on_area_2d_area_entered(area):
	if follow_path and follow_path.progress_ratio < 0.1:
		return
	
	# This is the end
	if area.collision_layer == 4:
		queue_free()
		return
	
	next_areas.append(area)

	if ! follow_path:
		call_deferred("_assign_next_path")


func _assign_next_path():
	var new_follow_path = PathFollow2D.new()
	new_follow_path.loop = false
	
	var next_area = next_areas[randi_range(0, next_areas.size() - 1)]
	var next_path: Path2D = next_area.get_node("Path2D")
	
	# Sometimes various transform aspects slowly change - why????
	scale = Vector2.ONE

	var rot =  get_node("..").rotation_degrees
	# When pointing up or down, reset x to re-align vertically. Intuitively this feels like it
	# should be resetting y, but the axes themselves have rotated.
	if rot == -90 || rot == 90:
		position.x = 0
	else:
		position.y = 0
	
	# If we're following a curve, then disable the traffic light detector so that sweeping
	# through the curve doesn't mis-detect something in the other lane.
	var curve: Curve2D = next_path.curve
	if abs(curve.get_point_position(0).x - curve.get_point_position(curve.point_count - 1).x) > 0 && \
			abs(curve.get_point_position(0).y - curve.get_point_position(curve.point_count - 1).y) > 0:
		$RayTrafficLightDetector.enabled = false
	else:
		$RayTrafficLightDetector.enabled = true
	
	next_path.add_child(new_follow_path)
	reparent(new_follow_path)
	if follow_path:
		follow_path.queue_free()
	
	follow_path = new_follow_path
	next_areas.clear()


func _on_car_body_area_entered(area):
	pass


func _on_scaling_up_animation_animation_finished(anim_name):
	max_speed = prepared_max_speed
