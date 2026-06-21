class_name Ring extends Sprite3D

const standard_ring = preload("res://resources/normal.tres")

@export var ring_resource: RingResource
@export var explosion_scene: PackedScene
@export var start_y = 3.0

@onready var base: Sprite3D = $Base

var target_pos: Vector3
var player = 0

func _ready() -> void:
	position = target_pos
	global_position.y = start_y
	texture = ring_resource.texture
	base.texture.region.position.x = (player - 1) * 16

func animate_to_pos():
	var tween = create_tween().set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT).set_parallel()
	tween.tween_property(self, "position", target_pos, 1.0)
	tween.tween_callback(func(): bounce(0)).set_delay(0.4)
	tween.tween_callback(func(): bounce(-3)).set_delay(0.75)
	tween.tween_callback(func(): bounce(-6)).set_delay(0.85)
	await tween.finished

func bounce(volume_db):
	Global.camera.shake(0.1, 0.005)
	# probably play a sound effect here
	AudioManager.play_sound(AudioManager.hit, 0, volume_db)

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
				await grid.destroy(i, col)
		RingResource.RingType.WEDDING:
			if grid.get_pos(row, col + 1) == null:
				return

			var temp = grid.get_pos(row, col)
			var one = grid.set_pos(grid.get_pos(row, col + 1), row, col)
			var two = grid.set_pos(temp, row, col + 1)

			var tween = create_tween().set_parallel().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
			tween.tween_property(one, "position:x", two.position.x, 0.5)
			tween.tween_property(two, "position:x", one.position.x, 0.5)
		RingResource.RingType.DOUBLE:
			# await grid.drop_ring(player, col, standard_ring)
			pass
		RingResource.RingType.COPY:
			var ring = grid.get_pos(row, col - 1) as Ring
			if ring != null and ring.ring_resource.type != RingResource.RingType.COPY:
				await ring.activate(grid, row, col)
		_:
			print("the ring activated doesn't have an ability")

func bump(dir: Vector2):
	var tween = create_tween()
	var original_pos = position
	position += Vector3(dir.x, dir.y, 0) * 0.075
	tween.tween_property(self, "position", original_pos, 0.2)
	AudioManager.play_sound(AudioManager.bump)

func destroy(mute: bool = false):
	if not mute:
		AudioManager.play_sound(AudioManager.explosion, 0, -6)
	var explosion = explosion_scene.instantiate() as AnimatedSprite3D
	visible = false
	get_parent().add_child(explosion)
	explosion.global_position = global_position
	Canvas.flash()
	explosion.play()
	await explosion.animation_finished
	queue_free()
	explosion.queue_free()
