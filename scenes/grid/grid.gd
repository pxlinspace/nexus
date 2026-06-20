class_name Grid extends Node3D

@export var rows = 6
@export var cols = 7
@export var grid_image_width = 128
@export var grid_image_height = 110
@export var ring_scene: PackedScene

@onready var front: Sprite3D = $Front

var grid: Array[Array]
var width: float
var height: float

func _ready() -> void:
	width = front.pixel_size * grid_image_width
	height = front.pixel_size * grid_image_height

	init_grid()

func _process(dt: float) -> void:
	if Input.is_action_just_pressed("s"):
		drop_ring(1, randi_range(0, cols - 1))

# fill the grid with nothing
func init_grid():
	for i in range(rows):
		var r = []
		for x in range(cols):
			r.append(0)
		grid.append(r)

# drops a ring in the specified column
func drop_ring(player: int, col: int):
	# start from the lowest row
	var row = rows - 1
	while row >= 0:
		if grid[row][col] == 0:
			break
		row -= 1

	if row == -1:
		# this means there is no space in the column
		print("there's no space in that column")
		return

	grid[row][col] = player

	# drop the actual ring visually
	get_parent().get_parent().flash()
	var ring = ring_scene.instantiate() as Ring
	ring.target_pos = Vector3(
		col * 18 * front.pixel_size + (10 * front.pixel_size),
		-(row * 18 * front.pixel_size + (10 * front.pixel_size)),
		0
	)
	add_child(ring)

	print(check_win())

func check_win():
	var directions = [
		Vector2(1, 0),
		Vector2(0, 1),
		Vector2(1, 1),
		Vector2(1, -1),
	]

	for r in range(rows):
		for c in range(cols):
			var player = grid[r][c]
			if player == 0:
				continue

			for dir in directions:
				var count = 1
				var cx = c + dir.x
				var cy = r + dir.y

				while cx >= 0 and cx < cols and cy >= 0 and cy < rows and grid[cy][cx] == player:
					count += 1
					if count >= 4:
						return player
					cx += dir.x
					cy += dir.y

	return 0
