class_name GridSelector extends Node2D

signal col_selected(col: int)

@export var grid_col_area_scene: PackedScene

# var hovered_col: GridColArea
var target_hand_x = 0

func _ready() -> void:
	# spawn mouse column areas
	var num_cols = Global.main.grid.cols
	for i in range(num_cols):
		var col = grid_col_area_scene.instantiate() as GridColArea
		col.index = i
		var width = col.get_node("CollisionShape").shape.size.x
		col.position.x = 640.0 / 2 - (width * num_cols) / 2 + i * width + (width / 2)
		col.position.y = 360.0 / 2
		add_child(col)
