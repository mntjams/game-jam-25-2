extends Node2D

class_name Room

@export var minigame_scene : PackedScene

@export var is_final_room : bool = false

# --- minigame handling ---

func start_minigame_for(woman: InteractableWoman, player: Player) -> void:
	if is_final_room:
		# TODO: implement some interaction with woman in front of taxi
		print("I am waiting for taxi honey")
		return
	var mg := minigame_scene.instantiate()
	mg.finished.connect(_on_minigame_finished.bind(woman, player))
	get_tree().current_scene.add_child(mg)
	mg.start()

func _on_minigame_finished(success: bool, interest_gained: float, woman: InteractableWoman, player: Player) -> void:
	player.finish_interaction()
	if success: player.do_particles()
	woman.finish_interaction(success, interest_gained)

# --- free slots handling ---

# get array of free slots
func get_free_slots() -> Array[Slot]:
	var free: Array[Slot] = []

	for child in get_children():
		if child is Slot and child.is_free():
			free.append(child as Slot)

	return free

# return first free slot and set it occupied right away
func get_first_free_slot() -> Slot:
	var free = get_free_slots()
	if free.is_empty():
		return null
	var slot = free.front();
	slot.occupied = true
	return slot

# return a random free slot of this room to the RoomManager
func get_random_free_slot() -> Slot:
	var free = get_free_slots()
	if free.is_empty():
		return null
	return free[randi() % free.size()]

# try to occupy the slot
func occupy_slot(slot: Slot) -> bool:
	if slot.is_free():
		slot.occupied = true
		return true
	return false

# release the current slot
func release_slot(slot: Slot) -> void:
	slot.occupied = false
