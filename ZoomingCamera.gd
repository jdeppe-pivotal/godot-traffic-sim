extends Camera2D

# Lower cap for the `_zoom_level`.
@export var min_zoom := 1.0
# Upper cap for the `_zoom_level`.
@export var max_zoom := 4.0
# Controls how much we increase or decrease the `_zoom_level` on every turn of the scroll wheel.
@export var zoom_factor := 0.01
# Duration of the zoom's tween animation.
@export var zoom_duration := 0.2

@export var pan_factor := 1.0

# The camera's target zoom level.
var zoom_level := 1.0 #setget _set_zoom_level


func _unhandled_input(event):
	if event is InputEventMagnifyGesture:
		if event.factor > 1.0:
		# Inside a given class, we need to either write `self._zoom_level = ...` or explicitly
		# call the setter function to use it.
			zoom_level += zoom_factor
		else:
			zoom_level -= zoom_factor

		zoom_level = clamp(zoom_level, min_zoom, max_zoom)
		set_zoom(Vector2(zoom_level, zoom_level))

	elif event is InputEventPanGesture:
		var delta = event.delta
		if delta.x < 0:
			position.x += pan_factor
		elif delta.x > 0:
			position.x -= pan_factor
		if delta.y < 0:
			position.y += pan_factor
		elif delta.y > 0:
			position.y -= pan_factor
