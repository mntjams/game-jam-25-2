extends CanvasLayer

class_name MiniGame

signal finished(success: bool)

@onready var timer : Timer = $Timer

func start() -> void:
	timer.start()
	print("minigame alive")

func _on_timer_timeout() -> void:
	print("minigame finished")
	emit_signal("finished", true)
	queue_free()
