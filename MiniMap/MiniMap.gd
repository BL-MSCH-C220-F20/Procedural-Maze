extends Sprite

onready var Player = get_node("/root/Game/Player")
onready var Terrain = get_node("/root/Game/Terrain")
export var map_region = Vector2(500,500)
var map_size = null
var tile_size = 0
var world_size = 1

func _ready():
	texture = $Viewport.get_texture()
	tile_size = Terrain.mini_tile_size
	world_size = Terrain.tile_size
	map_size = Vector2(tile_size.x*Terrain.width, tile_size.y*Terrain.height)

func _physics_process(_delta):
	var p = Player.global_transform.origin
	var off = Vector2(p.x,p.z)
	off *= tile_size / world_size
	position.x = (-off.x * scale.x * 0.98) - 10
	position.y = (-off.y * scale.y * 0.98) - 10
	get_parent().rotation_degrees = Player.rotation_degrees.y + 180
