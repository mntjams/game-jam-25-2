extends HSlider

signal finished_slotting(success: bool, interest_gained : float)

var interest_gained : float = 10
var shift : float = 10
var down_speed : float = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func start():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	var tween = get_tree().create_tween()
	if Input.is_action_just_pressed("slots"):
		tween.tween_property(self,"value", value+shift,delta)
		if value+shift >= 99: won()
	else: tween.tween_property(self,"value", value-down_speed,delta)

func won():
	print("won")
	emit_signal("finished_slotting", true, interest_gained)
	
	
