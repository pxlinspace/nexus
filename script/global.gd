extends Node

var camera: Camera
var main: Main
var time = 0.0

func wait(time: float):
	await get_tree().create_timer(time).timeout

func _process(dt: float) -> void:
	time += dt
