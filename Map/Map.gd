extends Spatial

const N = 1
const E = 2
const S = 4
const W = 8

var cell_walls = {Vector2(0, -1): N, Vector2(1, 0): E, 
				  Vector2(0, 1): S, Vector2(-1, 0): W}

var tile_size = 2  # tile size (in meters)
export var width = 20  # width of map (in tiles)
export var height = 12  # height of map (in tiles)

onready var mini_map = get_node("/root/Game/UI/Map_Container/MiniMap/Viewport/TileMap")
var mini_tile_size = 64

var map = []
var tiles = [
	preload("res://Map/Tile0.tscn")
	,preload("res://Map/Tile1.tscn")
	,preload("res://Map/Tile2.tscn")
	,preload("res://Map/Tile3.tscn")
	,preload("res://Map/Tile4.tscn")
	,preload("res://Map/Tile5.tscn")
	,preload("res://Map/Tile6.tscn")
	,preload("res://Map/Tile7.tscn")
	,preload("res://Map/Tile8.tscn")
	,preload("res://Map/Tile9.tscn")
	,preload("res://Map/Tile10.tscn")
	,preload("res://Map/Tile11.tscn")
	,preload("res://Map/Tile12.tscn")
	,preload("res://Map/Tile13.tscn")
	,preload("res://Map/Tile14.tscn")
	,preload("res://Map/Tile15.tscn")
]

# get a reference to the map for convenience

func _ready():
	randomize()
	mini_tile_size = mini_map.cell_size
	clear_map()
	make_maze()
	render_maze()


func clear_map():
	for x in range(width):
		map.append([])
		map[x].resize(height)
		for y in range(height):
			map[x][y] = 0

func check_neighbors(cell, unvisited):
	# returns an array of cell's unvisited neighbors
	var list = []
	for n in cell_walls.keys():
		if cell + n in unvisited:
			list.append(cell + n)
	return list
	
func make_maze():
	var unvisited = []  # array of unvisited tiles
	var stack = []
	# fill the map with solid tiles
	for x in range(width):
		for y in range(height):
			unvisited.append(Vector2(x, y))
			map[x][y] = N|E|S|W
			mini_map.set_cellv(Vector2(width-x,height-y),N|E|S|W)
	var current = Vector2(0, 0)
	unvisited.erase(current)
	# execute recursive backtracker algorithm
	while unvisited:
		var neighbors = check_neighbors(current, unvisited)
		if neighbors.size() > 0:
			var next = neighbors[randi() % neighbors.size()]
			stack.append(current)
			# remove walls from *both* cells
			var dir = next - current
			var current_walls = map[current.x][current.y] - cell_walls[dir]
			var next_walls = map[next.x][next.y] - cell_walls[-dir]
			map[current.x][current.y] = current_walls
			map[next.x][next.y] = next_walls
			mini_map.set_cellv(current, current_walls)
			mini_map.set_cellv(next, next_walls)
			current = next
			unvisited.erase(current)
		elif stack:
			current = stack.pop_back()

func render_maze():
	for x in range(width):
		for z in range(height):
			var t = tiles[map[x][z]].instance()
			t.translate_object_local(Vector3(x*tile_size,0,z*tile_size))
			t.name = "Tile_" + str(x) + "_" + str(z)
			add_child(t)
