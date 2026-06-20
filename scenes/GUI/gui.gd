extends Node2D

const HAND_UP_POSITION: Vector2 = Vector2(147.0, 384.0)
const HAND_DOWN_POSITION: Vector2 = Vector2(147.0, 688.0)

var selected_ring: FingerRing
var is_ring_used: bool = false
@onready var hand: Sprite2D = $Hand
@onready var mouse_area: Area2D = $MouseArea
@onready var rings: Node2D = $Hand/Rings
@onready var description_label: Label = $DescriptionLabel


func _ready() -> void:
	hand.position = HAND_DOWN_POSITION
	var tween = create_tween()
	tween.tween_property(hand, "position", HAND_UP_POSITION, 0.75) \
			.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUINT)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	mouse_area.position = get_local_mouse_position()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("select"):
		_use_selected_ring()

func _on_mouse_area_area_entered(area: Area2D) -> void:
	if is_ring_used:
		return
	selected_ring = area
	area.select()
	description_label.text = selected_ring.description


func _on_mouse_area_area_exited(area: Area2D) -> void:
	if is_ring_used:
		return
	area.deselect()


func _use_selected_ring() -> void:
	if not selected_ring:
		return
	is_ring_used = true
	selected_ring.reparent(self)
	var hand_tween = create_tween()
	hand_tween.tween_property(hand, "position", HAND_DOWN_POSITION, 0.75) \
			.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUINT)
	var ring_tween = create_tween()
	ring_tween.tween_property(selected_ring, "position", selected_ring.position + Vector2(0, -270.0), 0.4) \
			.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUART)
