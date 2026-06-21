extends Node2D

signal ring_selected(ring_resource: RingResource)

const HAND_UP_POSITION: Vector2 = Vector2(147.0, 384.0)
const HAND_DOWN_POSITION: Vector2 = Vector2(147.0, 688.0)

var hovered_ring: FingerRing
var is_ring_used: bool = false
@onready var hand: Sprite2D = $Hand
@onready var mouse_area: Area2D = $MouseArea
@onready var rings: Node2D = $Hand/Rings
@onready var description_label: Label = $DescriptionLabel
@onready var description_graphic: Sprite2D = $DescriptionGraphic
@onready var text_box: ColorRect = $TextBox


func _ready() -> void:
	hand.position = HAND_DOWN_POSITION
	var tween = create_tween()
	tween.tween_property(hand, "position", HAND_UP_POSITION, 0.75) \
			.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUINT)


func _process(_delta: float) -> void:
	mouse_area.position = get_local_mouse_position()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("select"):
		_begin_hovered_ring_animation()

func _on_mouse_area_area_entered(area: Area2D) -> void:
	if is_ring_used:
		return
	hovered_ring = area
	area.select()
	description_label.text = hovered_ring.ring_resource.desc
	text_box.show()
	if hovered_ring.ring_resource.desc_graphic:
		description_graphic.texture = hovered_ring.ring_resource.desc_graphic
	else:
		description_graphic.texture = null


func _on_mouse_area_area_exited(area: Area2D) -> void:
	if is_ring_used:
		return
	area.deselect()
	if hovered_ring == area:
		description_label.text = ""
		description_graphic.texture = null
		text_box.hide()

func _begin_hovered_ring_animation() -> void:
	if not hovered_ring:
		return
	is_ring_used = true
	hovered_ring.reparent(self)
	var ring_tween = create_tween()
	ring_tween.tween_property(hovered_ring, "position", hovered_ring.position + Vector2(0, -270.0), 0.4) \
			.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUART)

	var hand_tween = create_tween()
	hand_tween.tween_property(hand, "position", HAND_DOWN_POSITION, 0.75) \
			.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUINT)
	hand_tween.tween_callback(_use_hovered_ring)


func _use_hovered_ring() -> void:
	ring_selected.emit(hovered_ring.ring_resource)
	queue_free()
