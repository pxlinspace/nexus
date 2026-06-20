class_name Ring extends Sprite3D

@export var start_y = 0.5

var target_pos: Vector3

func _ready() -> void:
	position = target_pos
	position.y = start_y

	var tween = create_tween().set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT).set_parallel()
	tween.tween_property(self, "position", target_pos, 1.0)
	tween.tween_callback(func(): hit()).set_delay(0.4)
	tween.tween_callback(func(): hit()).set_delay(0.75)
	tween.tween_callback(func(): hit()).set_delay(0.85)

func hit():
	Global.camera.shake(0.1, 0.005)
	# probably play a sound effect here
