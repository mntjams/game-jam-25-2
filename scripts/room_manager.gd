extends Node
class_name RoomManager

var rooms: Array[Room] = []

func _ready() -> void:
	randomize() # for rand num generator
	_collect_rooms()
	_connect_existing_npcs()


# --- Room collection ---------------------------------------------------------

# initialize the rooms array
func _collect_rooms() -> void:
	rooms.clear()
	for child in get_children():
		if child is Room:
			rooms.append(child)


# --- NPC connection ----------------------------------------------------------

# connect all npc's from the npc group
func _connect_existing_npcs() -> void:
	for npc in get_tree().get_nodes_in_group("NPCs"):
		print(npc, "should be connected")
		_connect_npc(npc)

# connects single npc
func _connect_npc(npc: Npc) -> void:
	if not npc.ready_for_room.is_connected(_on_npc_ready_for_room):
		npc.ready_for_room.connect(_on_npc_ready_for_room)


# --- Room selection logic ----------------------------------------------------

# select a random room from the rooms array
func get_random_room_with_vacancy_excluding(excluded : Room) -> Room:
	var candidates: Array[Room] = []

	for r in rooms:
		if r == excluded:
			continue
		if not r.get_free_slots().is_empty():
			candidates.append(r)
	
	#print("candidate rooms are", candidates)
	
	if candidates.is_empty():
		return null

	return candidates[randi() % candidates.size()]


# --- Signal handler: NPC asks for a room ------------------------------------

func _on_npc_ready_for_room(npc: Npc, exclude : Room) -> void:
	#print("received signal from ", npc)
	var room := get_random_room_with_vacancy_excluding(exclude)
	if room == null:
		return  # no available slots in any room

	var slot := room.get_random_free_slot()
	if slot == null:
		return  # safety check; should not happen if get_random_room_with_vacancy is correct

	if room.occupy_slot(slot):
		npc.go_to_slot(room, slot)
