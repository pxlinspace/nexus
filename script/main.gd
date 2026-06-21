class_name Main extends Node3D


const CURTAINS_TRANSITION = preload("uid://fn5p7hp6wl0n")

@export var sky_scroll_amount = 3.0
@export var ring_selector_scene: PackedScene
@export var grid_selector_scene: PackedScene

@onready var environment: WorldEnvironment = $WorldEnvironment
@onready var sky_material: ProceduralSkyMaterial = environment.environment.sky.sky_material
@onready var noise: Noise = sky_material.sky_cover.noise
@onready var turntable: Node3D = $Turntable
@onready var hud_canvas: CanvasLayer = $HUD
@onready var round_text: Label3D = $Turntable/RoundText
@onready var curtains_transition: Node2D = $HUD/CurtainsTransition
@onready var rounds_win_text: RichTextLabel = $HUD/RoundWinText
@onready var scoreboard: Sprite3D = $Turntable/Scoreboard

@onready var player_data_1: PlayerData = $PlayerData1
@onready var player_data_2: PlayerData = $PlayerData2

var camera: Camera
var grid: Grid
var selected_ring_resource: RingResource

var round = 0
var curr_player = 1
var original_round_text_pos: Vector3

var player_1_score = 0
var player_2_score = 0

func _enter_tree() -> void:
	Global.main = self
	grid = $Turntable/Grid

func _ready() -> void:
	AudioManager.play_sound(AudioManager.music, 0, 4)
	original_round_text_pos = round_text.position
	next_round()

func next_round():
	curtains_transition.transition_out()
	# await Global.wait(1.0)
	grid.destroy_all()

	Global.camera.zoom(true)
	Global.camera.change_player(0)

	await Global.wait(1.75)

	round_text.rotation_degrees.x = 0
	round_text.position = original_round_text_pos
	round_text.text = "ROUND " + str(round + 1)
	var tween = create_tween().set_parallel().set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_IN)
	tween.tween_property(round_text, "position", Vector3(0, 1.117, 0.625), 0.75)
	tween.tween_property(round_text, "rotation_degrees:x", -90, 0.75)
	tween.chain().tween_callback(func(): AudioManager.play_sound(AudioManager.explosion, 0, -6))

	curr_player = 1 if round % 2 == 0 else 2

	var ring_selector = ring_selector_scene.instantiate()
	ring_selector.player_data = player_data_1 if curr_player == 1 else player_data_2
	ring_selector.ring_selected.connect(_on_ring_selector_ring_selected)
	ring_selector.set_player(curr_player)
	hud_canvas.add_child(ring_selector)
	Global.camera.change_player(1 if curr_player == 2 else -1)


func _on_sky_timer_timeout() -> void:
	turntable.rotation_degrees.y += sky_scroll_amount

func _on_ring_selector_ring_selected(ring_resource: RingResource) -> void:
	selected_ring_resource = ring_resource
	await Global.wait(0.0)
	Global.camera.change_player(0)
	# instantiate the column selector
	var grid_selector = grid_selector_scene.instantiate()
	grid_selector.set_player(curr_player)
	grid_selector.col_selected.connect(_on_grid_selector_col_selected)
	hud_canvas.add_child(grid_selector)

	# move scoreboard up
	var tween = create_tween().set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_OUT)
	tween.tween_property(scoreboard, "position:y", 6, 0.5)

func _on_grid_selector_col_selected(col: int) -> void:
	grid.drop_ring(curr_player, col, selected_ring_resource)

func _on_grid_ring_dropped() -> void:
	if curr_player == 1:
		player_data_1.increment_ring_ages()
	else:
		player_data_2.increment_ring_ages()

	var tween = create_tween().set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_OUT)
	tween.tween_property(scoreboard, "position:y", 2.737, 0.5)

	# check win first
	if grid.check_win() > 0:
		print("player " + str(grid.check_win()) + " wins!")
		rounds_win_text.text = "[wave]Player %s wins the round![/wave]" % curr_player

		update_player_score(curr_player, 1)

		curtains_transition.transition_in()

		tween = create_tween().set_trans(Tween.TRANS_SINE)
		tween.tween_property(rounds_win_text, "position:y", 0, 0.5).set_ease(Tween.EASE_OUT).set_delay(0.5)
		tween.tween_property(rounds_win_text, "position:y", -360, 0.5).set_ease(Tween.EASE_IN).set_delay(1.75)

		await Global.wait(3.0)

		#if round >= len(grid.grid_textures) - 1:
		if true:
			end_game()
			return

		next_round()
		round += 1
		grid.change_size(round)
		return

	curr_player = 1 if curr_player == 2 else 2
	var ring_selector = ring_selector_scene.instantiate()
	ring_selector.player_data = player_data_1 if curr_player == 1 else player_data_2
	ring_selector.ring_selected.connect(_on_ring_selector_ring_selected)
	ring_selector.set_player(curr_player)
	hud_canvas.add_child(ring_selector)
	Global.camera.change_player(1 if curr_player == 2 else -1)

func update_player_score(player: int, delta: int):
	if player == 1:
		player_1_score += delta
		scoreboard.get_node("Player1Score").text = str(player_1_score)
	else:
		player_2_score += delta
		scoreboard.get_node("Player2Score").text = str(player_2_score)

func end_game():
	rounds_win_text.text = "[wave]Player %s wins the game!!![/wave]" % ("1" if player_1_score > player_2_score else "2")
	var tween = create_tween().set_trans(Tween.TRANS_SINE)
	tween.tween_property(rounds_win_text, "position:y", 0, 0.5).set_ease(Tween.EASE_OUT).set_delay(0.5)
	await Global.wait(5.0)
	get_tree().reload_current_scene()
