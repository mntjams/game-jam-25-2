extends Node2D

class_name Room

# get array of free slots
func get_free_slots() -> Array[Slot]:
	var free: Array[Slot] = []

	for child in get_children():
		if child is Slot and child.is_free():
			free.append(child as Slot)

	return free

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
