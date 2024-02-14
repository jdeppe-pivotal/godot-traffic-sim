extends Node2D

@onready var car_1 = preload("res://car_1.tscn")

@export var min_speed: float = 50.0
@export var max_speed: float = 150.0


func _ready():
	_launch_car()


func _launch_car():
	var car = car_1.instantiate()
	car.prepared_max_speed = randf_range(min_speed, max_speed)
	add_child(car)
	
	#get_tree().create_timer(randf_range(1.0, 3.0)).timeout.connect(_launch_car)
	
func _unhandled_input(event):
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		_launch_car()
