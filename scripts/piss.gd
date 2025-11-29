extends Node2D

@onready var slider = $CanvasLayer/slider
@onready var text_rect = $CanvasLayer/slider/swee_spot
var finished = false
var dir = 1
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var sweet_spot = randf_range(0.1, 0.5)
	var margin = (1-sweet_spot) * slider.size.x
	text_rect.size.x -= margin
	text_rect.position.x += margin/2

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("slots"):
		finished = true
	
	if not finished:
		var tween = get_tree().create_tween()
		var val = slider.value
		var vel = 2+16/(abs(50-val)+1)
		print(vel)
		if val == slider.max_value or val == slider.min_value: dir*=-1
		tween.tween_property(slider,"value", val+dir*vel,delta)
		
