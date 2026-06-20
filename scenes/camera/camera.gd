class_name Camera extends Camera3D

@export var zoomed_z = 4.0
@export var zoomed_fov = 50.0
@export var zoom_speed = 1.0

var start_z = 0.0
var start_fov = 0.0
var target_z = 0.0
var target_fov = 0.0

func _ready() -> void:
	start_z = position.z
	start_fov = fov
	zoom(true)

func _process(dt: float) -> void:
	position.z = lerp(position.z, target_z, zoom_speed * dt)
	fov = lerp(fov, target_fov, zoom_speed * dt)

func zoom(enabled: bool):
	target_z = zoomed_z if enabled else start_z
	target_fov = zoomed_fov if enabled else start_fov
