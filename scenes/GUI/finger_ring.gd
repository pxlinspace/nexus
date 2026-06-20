class_name FingerRing extends Area2D

const RING_HOVER_OFFSET: Vector2 = Vector2(0.0, -10.0)

@export var description: String
var is_selected: bool = false


func select() -> void:
	is_selected = true
	var tween := create_tween()
	tween.tween_property(self, "position", RING_HOVER_OFFSET, 0.3) \
			.set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
	

func deselect() -> void:
	is_selected = false
	var tween := create_tween()
	tween.tween_property(self, "position", Vector2.ZERO, 0.3) \
			.set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
