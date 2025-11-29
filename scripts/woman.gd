extends Npc
class_name InteractableWoman

# CHANGE this to the real path of your "man" folder:
const MEN_COSTUMES_DIR := "res://assets/img/npc/man"
const WOMEN_COSTUMES_DIR := "res://assets/img/npc/woman"

var men_costume_textures: Array[Texture2D] = []
var women_costume_textures: Array[Texture2D] = []

@onready var sprite: Sprite2D = $Sprite2D

signal approached_by_player(woman : InteractableWoman, is_working : bool)
signal player_left(woman : InteractableWoman)

# --- Player tracking logic ---
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		emit_signal("approached_by_player",self, super.is_working())

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		emit_signal("player_left",self)

# --- BEHAVIOR LOGIC ---
func _ready() -> void:
	super._ready()
	men_costume_textures = _load_costumes(MEN_COSTUMES_DIR)
	women_costume_textures = _load_costumes(WOMEN_COSTUMES_DIR)
	_apply_random_costume()

func on_done_in_room() -> void:
	super.on_done_in_room()
	#print("I am a woman woohooo")


# --- COSTUMES HANDLING ---
func _load_costumes(from_path : String) -> Array[Texture2D]:
	var costume_textures : Array[Texture2D]
	var dir := DirAccess.open(from_path)
	if dir == null:
		push_error("Cannot open costumes dir: %s" % from_path)
		return []

	dir.list_dir_begin()
	var costume_paths: Array[String] = []
	while true:
		var file := dir.get_next()
		if file == "":
			break

		if dir.current_is_dir():
			continue
		if not file.ends_with(".png"):
			continue   # ignores .import and any non-png files

		var path := from_path + "/" + file
		
		costume_paths.append(path)

		var tex := load(path)
		if tex is Texture2D:
			costume_textures.append(tex)

	dir.list_dir_end()
	return costume_textures


func _apply_random_costume() -> void:
	var costume_textures = men_costume_textures + women_costume_textures
	if costume_textures.is_empty():
		return

	var idx := randi() % costume_textures.size()
	sprite.texture = costume_textures[idx]
