extends CanvasLayer

class_name MiniGame

signal finished(success: bool, interest_gained : float)

func start() -> void:
	await get_tree().create_timer(0.01).timeout
	print("test game finished")
	emit_signal("finished", true, 100.0)
	queue_free()
