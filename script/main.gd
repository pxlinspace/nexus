class_name Main extends Node3D

@export var sky_scroll_amount = 3.0

@onready var environment: WorldEnvironment = $WorldEnvironment
@onready var sky_material: ProceduralSkyMaterial = environment.environment.sky.sky_material
@onready var noise: Noise = sky_material.sky_cover.noise
@onready var turntable: Node3D = $Turntable

var camera: Camera
var grid: Grid

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
	await Global.wait(0.0)
	Global.camera.change_player(0)

func _on_grid_selector_col_selected(col: int) -> void:
	print(col)
