extends Node2D

signal finished(success: bool, interest_gained : float)

func start():
	pass

func _on_slot_finished_slotting(success, interest_gained):
	emit_signal("finished", success, interest_gained)
	queue_free()
