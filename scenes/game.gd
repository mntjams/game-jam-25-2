extends Node2D

var num_in_love : int = 0
var taxi_arriving : bool = false

@onready var taxi_path_follow = $TaxiStuff/TaxiPath2D/TaxiPathFollow2D
@onready var taxi_timer = $TaxiStuff/TaxiTimer
@onready var time_left_label = $CanvasLayer/TimeLeftLabel
@onready var fade_rect = $CanvasLayer/FadeRect

func _ready():
	_connect_existing_npcs()
	time_left_label.visible = false
	taxi_path_follow.visible = false

func _physics_process(_delta : float) -> void:
	update_label_by_timer()
	

func increase_num_in_love():
	if num_in_love == 0: # this is the first woman that fell in love
		taxi_timer.start()
		time_left_label.visible = true
	num_in_love += 1
	
	
# --- NPC connection for TAXI ----------------------------------------------------------

# connect all npc's from the npc group
func _connect_existing_npcs() -> void:
	for npc in get_tree().get_nodes_in_group("NPCs"):
		# print(npc, "should be connected")
		_connect_npc(npc)

# connects single npc
func _connect_npc(npc: Npc) -> void:
	if not npc.fallen_in_love.is_connected(_on_npc_in_love):
		npc.fallen_in_love.connect(_on_npc_in_love)
		# print("connected woman ",npc)

func _on_npc_in_love() -> void:
	increase_num_in_love()
	
# --- Taxi arrival ---

func update_label_by_timer():
	if num_in_love > 0 and not taxi_arriving:
		time_left_label.text = "Time left: " + str(roundi(taxi_timer.time_left))

func _on_taxi_timer_timeout():
	# print("taxi timed out")
	taxi_timer.stop()
	taxi_path_follow.visible = true
	taxi_arriving = true
	progress_taxi()
	
func progress_taxi():
	
	# first tween
	time_left_label.text = "Taxi arriving"
	var tween = create_tween()
	var target_offset : float = 0.5
	var duration : float = 3.0
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(taxi_path_follow, "progress_ratio", target_offset, duration)
	await tween.finished
	
	# wait some time
	time_left_label.text = "Gathering hoes"
	var taxi_wait_time = 2
	await get_tree().create_timer(taxi_wait_time).timeout
	
	# second tween
	time_left_label.text = "Taxi left"
	var tween2 := create_tween()
	tween2.set_ease(Tween.EASE_IN)
	tween2.tween_property(taxi_path_follow, "progress_ratio", 1.0, duration)
	await tween2.finished
	
	# remove taxi
	taxi_path_follow.visible = false
	fade_out()
	# TODO: implement game finish here!
	
	
	# --- FADING LOGIC ---

func fade_in(duration: float = 1.0) -> void:
	var tween := create_tween()
	tween.tween_property(fade_rect, "color:a", 0.0, duration)
	await tween.finished
	

func fade_out(duration: float = 1.0) -> void:
	print("fading")
	var tween := create_tween()
	tween.tween_property(fade_rect, "color:a", 1.0, duration)
	await tween.finished
