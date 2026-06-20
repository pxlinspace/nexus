class_name Grid extends Node3D

@export var rows = 6
@export var cols = 7

var grid: Array[Array]

func _ready() -> void:
	init_grid()

func _process(dt: float) -> void:
	pass

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

