extends Node2D

var woman_scene = preload("res://scenes/woman.tscn")
var kompars_scene = preload("res://scenes/kompars.tscn")
var player_scene = preload("res://scenes/player.tscn")
var player = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = player_scene.instantiate()
	add_child(player)
	for i in range(12):
		for j in range(12):
			if ((i+j)%5 == 0):
				GM.free_locations.append($TileMapLayer.map_to_local(Vector2i(i,j)))
	GM.free_locations.shuffle()
	for i in range(3):
		var woman = woman_scene.instantiate()
		woman.position = GM.free_locations[6+i]
		add_child(woman) 
	
	for i in range(20):
		for j in range(20):
			if ((i+j)%5 == 2):
				GM.kompars_locations.append($TileMapLayer.map_to_local(Vector2i(i,j)))
	GM.kompars_locations.shuffle()
	for i in range(3):
		var komp = kompars_scene.instantiate()
		komp.position = GM.kompars_locations[7+i]
		add_child(komp)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
