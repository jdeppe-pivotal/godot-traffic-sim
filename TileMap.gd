extends TileMap

@onready var road_1 = preload("res://road_1.tscn")
@onready var road_2 = preload("res://road_2.tscn")
@onready var road_3 = preload("res://road_3.tscn")
@onready var road_4 = preload("res://road_4.tscn")
@onready var road_5 = preload("res://road_5.tscn")
@onready var road_6 = preload("res://road_6.tscn")
@onready var road_7 = preload("res://road_7.tscn")
@onready var road_8 = preload("res://road_8.tscn")
@onready var road_9 = preload("res://road_9.tscn")
@onready var road_10 = preload("res://road_10.tscn")
@onready var road_11 = preload("res://road_11.tscn")

func _ready():
	var cells = get_used_cells(0)
	
	for i in range(len(cells)):
		var data = get_cell_tile_data(0, cells[i])
		if data:
			var x = data.get_custom_data("sprite")
			var path_tile : Node2D
			match x:
				"road_1":
					path_tile = road_1.instantiate()
				"road_2":
					path_tile = road_2.instantiate()
				"road_3":
					path_tile = road_3.instantiate()
				"road_4":
					path_tile = road_4.instantiate()
				"road_5":
					path_tile = road_5.instantiate()
				"road_6":
					path_tile = road_6.instantiate()
				"road_7":
					path_tile = road_7.instantiate()
				"road_8":
					path_tile = road_8.instantiate()
				"road_9":
					path_tile = road_9.instantiate()
				"road_10":
					path_tile = road_10.instantiate()
				"road_11":
					path_tile = road_11.instantiate()

			if path_tile:
				path_tile.get_node("Sprite2D").visible = false
				path_tile.position = map_to_local(cells[i])
				add_child(path_tile)
