class_name FingerRing extends Area2D

const RING_HOVER_OFFSET: Vector2 = Vector2(0.0, -10.0)

@export var ring_resource: RingResource
var is_hovered: bool = false
@onready var ring: Node2D = $Ring
@onready var gem: Sprite2D = $Ring/Gem


func _ready():
	gem.texture = ring_resource.texture


func select() -> void:
	is_hovered = true
	var tween := create_tween()
	tween.tween_property(ring, "position", RING_HOVER_OFFSET, 0.3) \
			.set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
	

func deselect() -> void:
	is_hovered = false
	var tween := create_tween()
	tween.tween_property(ring, "position", Vector2.ZERO, 0.3) \
			.set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
