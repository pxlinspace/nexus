extends Node2D

signal finished_transition_in
signal finished_transition_out

const CENTER_X: float = 320.0
const OFFSET_X: float = 350.0
const TWEEN_DURATION: float = 0.75

@onready var left_curtain: Sprite2D = $LeftCurtain
@onready var right_curtain: Sprite2D = $RightCurtain

func _ready() -> void:
	left_curtain.position.x = CENTER_X-OFFSET_X
	right_curtain.position.x = CENTER_X+OFFSET_X


func transition_in() -> void:
	var left_tween = create_tween()
	left_tween.tween_property(left_curtain, "position:x", CENTER_X, TWEEN_DURATION) \
			.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	var right_tween = create_tween()
	right_tween.tween_property(right_curtain, "position:x", CENTER_X, TWEEN_DURATION) \
			.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	right_tween.tween_callback(finished_transition_in.emit)


func transition_out() -> void:
	var left_tween = create_tween()
	left_tween.tween_property(left_curtain, "position:x", CENTER_X-OFFSET_X, TWEEN_DURATION) \
			.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUAD)
	var right_tween = create_tween()
	right_tween.tween_property(right_curtain, "position:x", CENTER_X+OFFSET_X, TWEEN_DURATION) \
			.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUAD)
	right_tween.tween_callback(finished_transition_out.emit)
	
