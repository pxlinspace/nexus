class_name Main extends Node3D

@export var sky_scroll_amount = 3.0
@export var ring_selector_scene: PackedScene
@export var grid_selector_scene: PackedScene

@onready var environment: WorldEnvironment = $WorldEnvironment
@onready var sky_material: ProceduralSkyMaterial = environment.environment.sky.sky_material
@onready var noise: Noise = sky_material.sky_cover.noise
@onready var turntable: Node3D = $Turntable
@onready var hud_canvas: CanvasLayer = $HUD
@onready var round_text: Label3D = $Turntable/RoundText

var camera: Camera
var grid: Grid
var selected_ring_resource: RingResource

var round = 0
var curr_player = 2

func _enter_tree() -> void:
	Global.main = self
	grid = $Turntable/Grid

func _ready() -> void:
	Global.camera.zoom(true)
	Global.camera.change_player(0)

	await Global.wait(1.5)

	var tween = create_tween().set_parallel().set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_IN)
	tween.tween_property(round_text, "position", Vector3(0, 1.117, 0.625), 0.75)
	tween.tween_property(round_text, "rotation_degrees:x", -90, 0.75)
	tween.chain().tween_callback(func(): AudioManager.play_sound(AudioManager.explosion))

	_on_grid_ring_dropped()

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
	grid.drop_ring(curr_player, col, selected_ring_resource)

func _on_grid_ring_dropped() -> void:
	var ring_selector = ring_selector_scene.instantiate()
	ring_selector.ring_selected.connect(_on_ring_selector_ring_selected)
	hud_canvas.add_child(ring_selector)
	curr_player = 1 if curr_player == 2 else 2
	Global.camera.change_player(1 if curr_player == 2 else -1)
