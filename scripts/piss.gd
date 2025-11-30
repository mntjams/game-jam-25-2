extends Node2D

@onready var slider = $CanvasLayer/slider
@onready var text_rect = $CanvasLayer/slider/swee_spot

var dir = 1
var interest_gained : float = 10
var finished_mini : bool = false
var sweet_spot = 0

signal finished(success: bool, interest_gained : float)


func start():
	pass

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sweet_spot = randf_range(0.2, 0.5)
	var margin = (1-sweet_spot) * slider.size.x
	text_rect.size.x -= margin
	text_rect.position.x += margin/2

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("slots"):
		var margin = ((1-sweet_spot)/2)*100
		print(slider.value)
		print(margin)
		if slider.value >= margin and slider.value <= 100-margin:
			won()
		else: lost()
			
		#TODO: fix sweet spot here
	
	if not finished_mini:
		var tween = get_tree().create_tween()
		var val = slider.value
		var vel = 2+16/(abs(50-val)+1)
		if val == slider.max_value or val == slider.min_value: dir*=-1
		tween.tween_property(slider,"value", val+dir*vel,delta)
		
func won():
	emit_signal("finished",true,interest_gained)
	queue_free()

func lost():
	emit_signal("finished",false,interest_gained)
	queue_free()
