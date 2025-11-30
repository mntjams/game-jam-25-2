extends Node2D

signal finished(success: bool, interest_gained : float)

var interest_gained : float = 10
var shift : float = 6
var down_speed : float = 0.2
@onready var slider = $CanvasLayer/slot
var ended = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	slider.value = randf_range(0.1, 0.4)*100

func start():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	
	if not ended:
		var tween = get_tree().create_tween()
		if Input.is_action_just_pressed("slots"):
			tween.tween_property(slider,"value", slider.value+shift,delta)
			if slider.value+shift >= 99:
				ended = true
				won()
		else: tween.tween_property(slider,"value", slider.value-down_speed,delta)

func won():
	print("won")
	$CanvasLayer/slot/CPUParticles2D.emitting = true
	await get_tree().create_timer(1).timeout
	emit_signal("finished", true, interest_gained)
	queue_free()
	
	
