extends Node3D

@export var sky_scroll_amount = 3.0

@onready var environment: WorldEnvironment = $WorldEnvironment

@onready var sky_material: ProceduralSkyMaterial = environment.environment.sky.sky_material
@onready var noise: Noise = sky_material.sky_cover.noise

@onready var turntable: Node3D = $Turntable

var camera: Camera

func _on_sky_timer_timeout() -> void:
	turntable.rotation_degrees.y += sky_scroll_amount
