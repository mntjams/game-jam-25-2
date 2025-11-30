extends Node2D

var num_in_love : int = 0

@onready var taxi_timer = $TaxiTimer
@onready var time_left_label = $CanvasLayer/TimeLeftLabel

func _ready():
	_connect_existing_npcs()
	time_left_label.visible = false

func _physics_process(_delta : float) -> void:
	update_label_by_timer()

func increase_num_in_love():
	if num_in_love == 0: # this is the first woman that fell in love
		taxi_timer.start()
		time_left_label.visible = true
		print("here")
	num_in_love += 1
	print(num_in_love)
	
	
# --- NPC connection ----------------------------------------------------------

# connect all npc's from the npc group
func _connect_existing_npcs() -> void:
	for npc in get_tree().get_nodes_in_group("NPCs"):
		# print(npc, "should be connected")
		_connect_npc(npc)

# connects single npc
func _connect_npc(npc: Npc) -> void:
	if not npc.fallen_in_love.is_connected(_on_npc_in_love):
		npc.fallen_in_love.connect(_on_npc_in_love)
		print("connected woman ",npc)

func _on_npc_in_love() -> void:
	increase_num_in_love()
	
# --- Taxi label update ---

func update_label_by_timer():
	if num_in_love > 0:
		time_left_label.text = "Time left: " + str(roundi(taxi_timer.time_left))
		
