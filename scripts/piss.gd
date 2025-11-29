extends Node2D

@onready var good = $CanvasLayer/good
var finished = false
var dir = 1
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var shift = randf_range(0.25, 0.4)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("slots"):
		finished = true
	
	if not finished:
		var tween = get_tree().create_tween()
		var val = good.value
		var vel = 2+16/(abs(50-val)+1)
		print(vel)
		if val == good.max_value or val == good.min_value: dir*=-1
		tween.tween_property(good,"value", good.value+dir*vel,delta)
		
