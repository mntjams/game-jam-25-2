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

@onready var progress_bar : ProgressBar = $Sprite2D/ProgressBar

const INTEREST_LIMIT : float = 100.0
var player_in_range: bool = false
var interest : float = 0

# --- Player spotting logic

func is_player_visible() -> bool:
	for b in $SpottingArea.get_overlapping_bodies():
		if b is Player:
			return true
	return false

func _on_spotting_area_body_entered(body):
	if body is Player:
		if body.is_interacting:
			# TODO: spotted when girl entered
			print("What are you doing with this woman!")

# check if started 
func _on_player_started_interacting(woman : InteractableWoman):
	if woman != self and is_player_visible():
		# TODO: player started interacting with other woman
		print("You started interacting with this girl when I am here!")

func _subscribe_to_player_interaction_signal() -> void:
	var player := get_tree().get_first_node_in_group("Player")
	
	if not player.started_interacting_with.is_connected(_on_player_started_interacting):
		player.started_interacting_with.connect(_on_player_started_interacting)

# --- Interest bar logic

func _init_interest_bar() -> void:
	animate_progress_bar(interest)


func is_working() -> bool:
	return super.is_working()

# start interacting with the player
func start_interaction(player : Player) -> void:
	#print(self, "hi boy. you are ",player)
	super._stop_stuck_timer()
	super.set_interacting(true)
	current_room.start_minigame_for(self, player)

func fall_in_love():
	# print("I am going to final room now")
	in_love = true
	super.go_to_final_room()
	super.emit_fallen_in_love()

# finish interacting with player and leave
func finish_interaction(success : bool, interest_gained : float) -> void:
	if success:
		gain_interest(interest_gained)
	super.set_working(false)
	super.set_interacting(false)
	if in_love:
		return
	super._restart_stuck_timer()
	super.on_done_in_room()

func animate_progress_bar(interest_gained : float):
	var tween = get_tree().create_tween()
	var fill := StyleBoxFlat.new()
	if interest_gained > 0:
		fill.bg_color = Color("#60b200b0") # dark gray
	elif interest_gained < 0:
		fill.bg_color = Color.DARK_RED
	progress_bar.add_theme_stylebox_override("fill", fill)
	tween.tween_property(progress_bar, "value", interest, 0.5)
	await tween.finished
	fill.bg_color = Color("#60b200b0")
	progress_bar.add_theme_stylebox_override("fill", fill)

func gain_interest(interest_gained : float):
	#print(self," You cool dude, I am really interested")
	interest = clamp(interest + interest_gained, 0.0, 100.0)
	animate_progress_bar(interest_gained)
	if interest >= INTEREST_LIMIT:
		fall_in_love()

# --- Player tracking logic ---
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		player_in_range = true
		emit_signal("approached_by_player",self, super.is_working())


func _on_area_2d_body_exited(body: Node2D) -> void:
	player_in_range = false
	if body.name == "Player":
		emit_signal("player_left",self)

# --- BEHAVIOR LOGIC ---
func _ready() -> void:
	super._ready()
	men_costume_textures = _load_costumes(MEN_COSTUMES_DIR)
	women_costume_textures = _load_costumes(WOMEN_COSTUMES_DIR)
	_subscribe_to_player_interaction_signal()
	_apply_random_costume()
	_init_interest_bar()

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
