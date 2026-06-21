class_name MainMenu extends Node3D

@export var sky_scroll_amount = 3.0

@onready var turntable: Node3D = $Turntable

func _on_sky_timer_timeout() -> void:
	turntable.rotation_degrees.y += sky_scroll_amount

