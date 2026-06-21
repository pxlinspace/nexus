class_name MainMenu extends Node3D

@export var sky_scroll_amount = 3.0

@onready var turntable: Node3D = $Turntable

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("select"):
		get_tree().change_scene_to_file("res://main.tscn")

func _process(dt: float) -> void:
	$Turntable/Label3D.position.y = 10.9 + sin(Global.time * 3.0) * 0.1
	$Turntable/Label3D.rotation_degrees.y = sin(Global.time * 3.0) * 25
	$Turntable/Label3D.rotation_degrees.x = sin(Global.time * 6.0) * 25

func _on_sky_timer_timeout() -> void:
	turntable.rotation_degrees.y += sky_scroll_amount
