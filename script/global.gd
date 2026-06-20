extends Node

var camera: Camera

func wait(time: float):
	await get_tree().create_timer(time).timeout
