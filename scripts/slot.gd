extends Node2D
class_name Slot

var occupied: bool = false

func is_free() -> bool:
	return not occupied
