class_name Grid extends Node3D

signal ring_dropped

@export var grid_image_width = 128
@export var grid_image_height = 110
@export var ring_scene: PackedScene
@export var grid_textures: Array[Texture2D]

@onready var front: Sprite3D = $Front
@onready var back: Sprite3D = $Back

var rows = 6
var cols = 7

var grid: Array[Array]
var width: float
var height: float

func _ready() -> void:
	width = $Front.pixel_size * grid_image_width
	height = $Front.pixel_size * grid_image_height

	front.offset.y = -(11 + (18 * rows))
	back.offset.y = -(11 + (18 * rows))
	front.offset.x = -6
	back.offset.x = -6

	init_grid()

# fill the grid with nothing
func init_grid():
	for i in range(rows):
		var r = []
		for x in range(cols):
			r.append(null)
		grid.append(r)

# drops a ring in the specified column
func drop_ring(player: int, col: int, resource: RingResource):
	# start from the lowest row
	print(rows)
	var row = rows - 1
	while row >= 0:
		if grid[row][col] == null:
			break
		row -= 1

	if row == -1:
		# this means there is no space in the column
		print("there's no space in that column")
		return

	# drop the actual ring visually
	Canvas.flash()
	var ring = ring_scene.instantiate() as Ring
	ring.ring_resource = resource
	ring.player = player
	grid[row][col] = ring
	ring.target_pos = Vector3(
		col * 18 * front.pixel_size + (10 * front.pixel_size),
		-(row * 18 * front.pixel_size + (10 * front.pixel_size)),
		0
	)

	add_child(ring)
	await ring.animate_to_pos()
	await Global.wait(0.4)
	await ring.activate(self, row, col)
	await Global.wait(0.4)

	ring_dropped.emit()

func set_pos(val: Ring, row: int, col: int):
	var r = wrapi(row, 0, rows)
	var c = wrapi(col, 0, cols)
	grid[r][c] = val
	return grid[r][c]

func get_pos(row: int, col: int):
	var r = wrapi(row, 0, rows)
	var c = wrapi(col, 0, cols)
	return grid[r][c]

# destroys a ring in the grid at the specified position
func destroy(row: int, col: int):
	var r = wrapi(row, 0, rows)
	var c = wrapi(col, 0, cols)

	var target = grid[r][c]
	if target:
		Global.camera.shake(0.1, 0.02)
		await target.destroy()
		grid[r][c] = null

	for i in range(r - 1, -1, -1):
		if grid[i][c]:
			var temp = grid[i][c]
			grid[i][c].target_pos.y -= 18 * front.pixel_size
			grid[i][c].animate_to_pos()
			grid[i][c] = null
			grid[i + 1][c] = temp

func check_win():
	var directions = [
		Vector2(1, 0),
		Vector2(0, 1),
		Vector2(1, 1),
		Vector2(1, -1),
	]

	for r in range(rows):
		for c in range(cols):
			var ring = grid[r][c]
			if ring == null:
				continue

			for dir in directions:
				var count = 1
				var cx = c + dir.x
				var cy = r + dir.y

				while cx >= 0 and cx < cols and cy >= 0 and cy < rows and grid[cy][cx] != null and ring != null and grid[cy][cx].player == ring.player:
					count += 1
					if count >= 2:
						return ring.player
					cx += dir.x
					cy += dir.y

	return 0

func destroy_all():
	for row in range(rows):
		for col in range(cols):
			if grid[row][col] != null:
				destroy(row, col)

func change_size(idx: int):
	print("index: " + str(idx))
	print("rows: " + str(rows) + ", cols: " + str(cols))

	if idx % 2 == 0:
		rows -= 1
	else:
		cols -= 1

	print("rows after: " + str(rows) + ", cols after: " + str(cols))

	front.texture = grid_textures[idx]
	back.texture = grid_textures[idx]

	front.offset.y = -(11 + (18 * rows))
	back.offset.y = -(11 + (18 * rows))
	front.offset.x = -6
	back.offset.x = -6
