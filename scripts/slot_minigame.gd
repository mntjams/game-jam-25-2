extends HSlider

var shift = 2.5
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	var tween = get_tree().create_tween()
	if Input.is_action_pressed("slots"):
		tween.tween_property(self,"value", value+shift,delta)
		if value+shift >= 99: print("won")
	else: tween.tween_property(self,"value", value-1,delta)
