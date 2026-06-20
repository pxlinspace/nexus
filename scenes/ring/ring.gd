class_name Ring extends Sprite3D

@export var start_y = 0.5

var target_pos: Vector3

func _ready() -> void:
	position = target_pos
	position.y = start_y

	var tween = create_tween().set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "position", target_pos, 1.0)

