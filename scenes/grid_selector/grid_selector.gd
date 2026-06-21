class_name GridSelector extends Node2D

signal col_selected(col: int)

@export var grid_col_area_scene: PackedScene
@onready var mouse_area: Area2D = $MouseArea
@onready var grid_columns: Node2D = $GridColumns
@onready var pinch_hand: Sprite2D = $PinchHand

# var hovered_col: GridColArea
var hovered_col_index: int = -1
var target_hand_x = 0.0

func _ready() -> void:
	# spawn mouse column areas
	var num_cols = Global.main.grid.cols
	for i in range(num_cols):
		var col = grid_col_area_scene.instantiate() as GridColArea
		var width = col.get_node("CollisionShape").shape.size.x
		col.position.x = 640.0 / 2 - (width * num_cols) / 2 + i * width + (width / 2)
		col.position.y = 360.0 / 2
		grid_columns.add_child(col)

	target_hand_x = get_global_mouse_position().x
	var tween = create_tween().set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_OUT)
	tween.tween_property(pinch_hand, "position:y", 24, 0.5)

func _process(dt: float) -> void:
	mouse_area.position = get_local_mouse_position()
	pinch_hand.position.x = lerp(pinch_hand.position.x, target_hand_x, 20.0 * dt)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("select") and hovered_col_index >= 0:
		col_selected.emit(hovered_col_index)
		var tween = create_tween().set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_IN)
		tween.tween_property(pinch_hand, "position:y", -40, 0.5)
		await tween.finished
		queue_free()


func _on_mouse_area_area_entered(area: Area2D) -> void:
	hovered_col_index = area.get_index()
	target_hand_x = area.position.x


func _on_mouse_area_area_exited(_area: Area2D) -> void:
	if mouse_area.get_overlapping_areas().is_empty():
		hovered_col_index = -1
