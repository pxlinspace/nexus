extends Node2D

signal ring_selected(ring_resource: RingResource)

@export var accent_color: Color

const HAND_UP_POSITION_Y: float = 384.0
const HAND_DOWN_POSITION_Y: float = 720.0

var hovered_ring: FingerRing
var is_ring_used: bool = false
@onready var hand: Sprite2D = $Hand
@onready var mouse_area: Area2D = $MouseArea
@onready var rings: Node2D = $Hand/Rings
@onready var description_label: RichTextLabel = $Description/DescriptionLabel
@onready var description_graphic: Sprite2D = $Description/DescriptionGraphic
@onready var text_box: ColorRect = $Description/TextBox

var player_data: PlayerData


func _ready() -> void:
	hand.position.y = HAND_DOWN_POSITION_Y
	var tween = create_tween()
	tween.tween_property(hand, "position", Vector2(hand.position.x, HAND_UP_POSITION_Y), 0.75) \
			.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUINT)

	text_box.hide()
	description_label.visible_ratio = 0
	
	for i in range(player_data.ring_resources.size()):
		if player_data.ring_resources[i] != null:
			rings.get_child(i).ring_resource = player_data.ring_resources[i]
			print(rings.get_child(i).ring_resource.name)

func _process(_delta: float) -> void:
	mouse_area.position = get_local_mouse_position()
	hand.position.y = HAND_UP_POSITION_Y + sin(Global.time * 2.0) * 1.0

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("select"):
		_begin_hovered_ring_animation()

func _on_mouse_area_area_entered(area: Area2D) -> void:
	if is_ring_used:
		return
	if area is FingerRing:
		hovered_ring = area
		area.select()
		description_label.text = "[b]" + hovered_ring.ring_resource.name + "[/b]" + "\n\n" + hovered_ring.ring_resource.desc
		text_box.show()
		if hovered_ring.ring_resource.desc_graphic:
			description_graphic.texture = hovered_ring.ring_resource.desc_graphic
		else:
			description_graphic.texture = null

		for ring in rings.get_children():
			if ring == hovered_ring:
				continue
			ring.deselect()

		description_label.visible_ratio = 0
		var tween = create_tween()
		tween.tween_property(description_label, "visible_ratio", 1.0, 0.3)

func _on_mouse_area_area_exited(area: Area2D) -> void:
	if is_ring_used or area != hovered_ring:
		return
	area.deselect()
	description_label.text = ""
	description_graphic.texture = null
	text_box.hide()

func _begin_hovered_ring_animation() -> void:
	if not hovered_ring:
		return

	text_box.visible = false
	description_graphic.visible = false
	description_label.visible = false

	is_ring_used = true
	hovered_ring.reparent(self)
	var ring_tween = create_tween()
	ring_tween.tween_property(hovered_ring, "position", hovered_ring.position + Vector2(0, -280.0), 0.4) \
			.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUART)

	await Global.wait(0.5)

	var hand_tween = create_tween()
	hand_tween.tween_property(hand, "position", Vector2(hand.position.x, HAND_DOWN_POSITION_Y), 0.75) \
			.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUINT)
	hand_tween.tween_callback(_use_hovered_ring)


func _use_hovered_ring() -> void:
	ring_selected.emit(hovered_ring.ring_resource)
	player_data.replace_ring(int(hovered_ring.name) - 1)
	queue_free()


func set_player(player: int) -> void:
	if player == 1:
		# change the color
		$Hand.self_modulate = accent_color
	else:
		# flip the x
		for node in get_children():
			node.position.x = 640.0 - node.position.x
