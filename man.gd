extends Npc
class_name ManNpc

# Folder containing all costume sprites
const COSTUME_DIR := "res://assets/npc/man/"

@onready var sprite: Sprite2D = $Sprite2D

func _ready() -> void:
	super._ready()
	_assign_random_costume()


func _assign_random_costume() -> void:
	var dir := DirAccess.open(COSTUME_DIR)
	if dir == null:
		push_error("Cannot open man costume directory: " + COSTUME_DIR)
		return

	var files: Array[String] = []
	dir.list_dir_begin()

	while true:
		var file := dir.get_next()
		if file == "":
			break

		# Skip directories
		if dir.current_is_dir():
			continue

		# Only PNG files
		if file.ends_with(".png"):
			files.append(file)

	dir.list_dir_end()

	if files.is_empty():
		push_error("No costume PNGs found in: " + COSTUME_DIR)
		return

	# Choose one at random
	var random_file := files[randi() % files.size()]
	var texture := load(COSTUME_DIR + random_file)

	# Assign to sprite
	sprite.texture = texture
