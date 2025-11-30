extends CanvasLayer

class_name MiniGame

var interest_reward : float = 100

signal finished(success: bool, interest_gained : float)

func start() -> void:
	await get_tree().create_timer(0.01).timeout
	# print("test game finished")
	emit_signal("finished", true, interest_reward)
	queue_free()
