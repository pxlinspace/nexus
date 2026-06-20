class_name Camera extends Camera3D

@export var zoom_speed = 4.0
@export var player_animation_speed = 10.0
@export var shake_damping_speed = 2.0
@export var zoomed_z = 4.0
@export var extra_zoomed_z = 2.0
@export var zoomed_fov = 50.0
@export var player_x_offset = 0.3
@export var player_y_rot = 9.0

var start_z = 0.0
var start_fov = 0.0
var target_z = 0.0
var target_fov = 0.0
var target_x = 0.0
var target_y_rot = 0.0

var shake_duration = 0
var shake_magnitude = 0
var original_pos = Vector2.ZERO

func _enter_tree() -> void:
	Global.camera = self

func _ready() -> void:
	start_z = position.z
	start_fov = fov
	zoom(true)
	change_player(0)
	original_pos = Vector2(h_offset, v_offset)

func _process(dt: float) -> void:
	position.z = lerp(position.z, target_z, zoom_speed * dt)
	fov = lerp(fov, target_fov, zoom_speed * dt)
	position.x = lerp(position.x, target_x, player_animation_speed * dt)
	rotation_degrees.y = lerp(rotation_degrees.y, target_y_rot, player_animation_speed * dt)

	if Input.is_action_just_pressed("a"):
		change_player(-1)
	if Input.is_action_just_pressed("d"):
		change_player(1)
	if Input.is_action_just_pressed("w"):
		change_player(0)

	h_offset = original_pos.x
	v_offset = original_pos.y
	if shake_duration > 0:
		h_offset += randf_range(0, PI*2) * shake_magnitude
		v_offset += randf_range(0, PI*2) * shake_magnitude
		shake_duration -= dt * shake_damping_speed
	else:
		shake_duration = 0

func zoom(enabled: bool):
	target_z = zoomed_z if enabled else start_z
	target_fov = zoomed_fov if enabled else start_fov

func shake(duration: float, magnitude: float):
	shake_duration = duration
	shake_magnitude = magnitude

# pass in -1 for left player and 1 for right player
func change_player(dir: int):
	target_x = dir * player_x_offset
	target_y_rot = -dir * player_y_rot
	target_z = extra_zoomed_z if dir == 0 else zoomed_z
