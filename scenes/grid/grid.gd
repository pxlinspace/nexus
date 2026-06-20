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
	while row > 0:
		if grid[row][col] == 0:
			break
		row -= 1

	if row == -1:
		# this means there is no space in the column
		return

	grid[row][col] = player

	# drop the actual ring visually
	var ring = ring_scene.instantiate() as Ring
	ring.target_pos = Vector3(
		col * 18 * front.pixel_size + (10 * front.pixel_size),
		-(row * 18 * front.pixel_size + (10 * front.pixel_size)),
		-0.01
	)
	add_child(ring)

func check_win():
	# check each row
	for row in grid:
		if row.all(func(n: int): return n == row[0]) and row[0] != 0:
			return row[0]

	# check each column
	for i in range(cols):
		var c = []
		for x in range(rows):
			c.append(grid[x][i])
		if c.all(func(n: int): return n == c[0]) and c[0] != 0:
			return c[0]

	return 0
