extends Spatial

var Tile = preload("res://Scenes/Tile0.tscn")
var tile_size = 2
var ground_size = 30
var map = []
var count = 0
var initial_value = ""

func initialize_map(width, height, value):
	var to_return = []
	for y in range(height):
		to_return.append([])
		to_return[y].resize(width)
		for x in range(width):
			to_return[y][x] = value
	return to_return

func create_tile(u,v,width,height,count):
	var t = Tile.instance()
	var x = (u - int(ceil(width/2)))*tile_size
	var z = (v - int(ceil(height/2)))*tile_size
	t.translate_object_local(Vector3(x,0,z))
	t.name = "Tile_" + str(count)
	return t

func check_map(map):
	for v in range(map.size()):
		for u in range(map[v].size()):
			if (map[v][u] == ""):
				var t1 = create_tile(u,v,map[0].size(),map.size(),count)
				count += 1
				map[v][u] = t1.name
				add_child(t1)
	return map
	

func append_row(map, value):
	map.push_back([])
	var s = map.size()-1
	map[s].resize(map[0].size())
	for u in range(map[s].size()):
		map[s][u] = value
	map = check_map(map)
	return map

func prepend_row(map, value):
	map.push_front([])
	map[0].resize(map[1].size())
	for u in range(map[0].size()):
		map[0][u] = value
	map = check_map(map)
	return map

func append_column(map, value):
	for v in range(map.size()):
		map[v].push_back(value)
	map = check_map(map)
	return map

func prepend_column(map, value):
	for v in range(map.size()):
		map[v].push_front(value)
	map = check_map(map)
	return map


func _ready():
	var width = int(ceil(ground_size / tile_size))
	var height = int(ceil(ground_size / tile_size))
	map = initialize_map(width, height, initial_value)
	for v in range(map.size()):
		for u in range(map[v].size()):
			var t = create_tile(u,v,map[v].size(),map.size(),count)
			count += 1
			map[u][v] = t.name
			add_child(t)
	var u = map.size()
	var v = map[0].size()
	var t = get_node(map[0][0])
	var m = SpatialMaterial.new()
	m.albedo_color = Color(1,0,0,1)
	t.get_node("StaticBody/MeshInstance").set_surface_material(0,m)
	t = get_node(map[u-1][0])
	m = SpatialMaterial.new()
	m.albedo_color = Color(0,1,0,1)
	t.get_node("StaticBody/MeshInstance").set_surface_material(0,m)
	t = get_node(map[u-1][v-1])
	m = SpatialMaterial.new()
	m.albedo_color = Color(0,0,1,1)
	t.get_node("StaticBody/MeshInstance").set_surface_material(0,m)
	t = get_node(map[0][v-1])
	m = SpatialMaterial.new()
	m.albedo_color = Color(1,0,1,1)
	t.get_node("StaticBody/MeshInstance").set_surface_material(0,m)

func _physics_process(delta):
	var h = map.size()-1
	var w = map[0].size()-1
	var updated = false
	var t = get_node(map[0][0])
	if t.get_global_transform().origin.x > -14:
		map = prepend_column(map, initial_value)
		updated = true
	if t.get_global_transform().origin.z > -14:
		map = prepend_row(map, initial_value)
		updated = true
	if not updated:
		t = get_node(map[h][w])
		print(t.get_global_transform().origin)
		if t.get_global_transform().origin.x < 14:
			map = append_column(map, initial_value)
		if t.get_global_transform().origin.z < 14:
			map = append_row(map, initial_value)
