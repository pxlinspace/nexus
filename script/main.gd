class_name Main extends Node3D

@export var sky_scroll_amount = 3.0
@export var ring_selector_scene: PackedScene
@export var grid_selector_scene: PackedScene

@onready var environment: WorldEnvironment = $WorldEnvironment
@onready var sky_material: ProceduralSkyMaterial = environment.environment.sky.sky_material
@onready var noise: Noise = sky_material.sky_cover.noise
@onready var turntable: Node3D = $Turntable
@onready var hud_canvas: CanvasLayer = $HUD

var camera: Camera
var grid: Grid
var selected_ring_resource: RingResource

var round = 0
var curr_player = 1

func _enter_tree() -> void:
	Global.main = self
	grid = $Turntable/Grid

func _ready() -> void:
	Global.camera.zoom(true)
	Global.camera.change_player(-1)

func _on_sky_timer_timeout() -> void:
	turntable.rotation_degrees.y += sky_scroll_amount

func _on_ring_selector_ring_selected(ring_resource: RingResource) -> void:
	selected_ring_resource = ring_resource
	await Global.wait(0.0)
	Global.camera.change_player(0)
	# instantiate the column selector
	var grid_selector = grid_selector_scene.instantiate()
	grid_selector.col_selected.connect(_on_grid_selector_col_selected)
	hud_canvas.add_child(grid_selector)

func _on_grid_selector_col_selected(col: int) -> void:
	print(col)
	grid.drop_ring(curr_player, col, selected_ring_resource)

func _on_grid_ring_dropped() -> void:
	curr_player = 1 if curr_player == 2 else 2
	print(curr_player)
	var ring_selector = ring_selector_scene.instantiate()
	ring_selector.ring_selected.connect(_on_ring_selector_ring_selected)
	ring_selector.set_player(curr_player)
	hud_canvas.add_child(ring_selector)
	
	Global.camera.change_player(1 if curr_player == 2 else -1)
