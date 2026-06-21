class_name Ring extends Sprite3D

@export var ring_resource: RingResource
@export var explosion_scene: PackedScene
@export var start_y = 0.5

@onready var base: Sprite3D = $Base

var target_pos: Vector3
var player = 0

func _ready() -> void:
	position = target_pos
	position.y = start_y
	texture = ring_resource.texture
	base.texture.region.position.x = (player - 1) * 16

func animate_to_pos():
	var tween = create_tween().set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT).set_parallel()
	tween.tween_property(self, "position", target_pos, 1.0)
	tween.tween_callback(func(): bounce()).set_delay(0.4)
	tween.tween_callback(func(): bounce()).set_delay(0.75)
	tween.tween_callback(func(): bounce()).set_delay(0.85)
	await tween.finished

func bounce():
	Global.camera.shake(0.1, 0.005)
	# probably play a sound effect here
	AudioManager.play_sound(AudioManager.hit)

func activate(grid: Grid, row: int, col: int):
	match ring_resource.type:
		RingResource.RingType.SPADES_BOTTOM_LEFT:
			bump(Vector2(-1, -1))
			await grid.destroy(row + 1, col - 1)
		RingResource.RingType.CLUBS_BOTTOM_RIGHT:
			bump(Vector2(1, -1))
			await grid.destroy(row + 1, col + 1)
		RingResource.RingType.HEARTS_LEFT:
			bump(Vector2(-1, 0))
			await grid.destroy(row, col - 1)
		RingResource.RingType.DIAMONDS_RIGHT:
			bump(Vector2(1, 0))
			await grid.destroy(row, col + 1)
		RingResource.RingType.HEAVY:
			for i in range(row + 1, grid.rows):
				bump(Vector2(0, 1))
				await grid.destroy(i, col)
		_:
			print("the ring activated doesn't have an ability")

func bump(dir: Vector2):
	var tween = create_tween()
	var original_pos = position
	position += Vector3(dir.x, dir.y, 0) * 0.075
	tween.tween_property(self, "position", original_pos, 0.2)

func destroy():
	AudioManager.play_sound(AudioManager.explosion)
	var explosion = explosion_scene.instantiate() as AnimatedSprite3D
	visible = false
	get_parent().add_child(explosion)
	explosion.global_position = global_position
	Canvas.flash()
	explosion.play()
	await explosion.animation_finished
	queue_free()
	explosion.queue_free()
