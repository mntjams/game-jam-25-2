extends Node2D
@onready var full = $CanvasLayer/full
@onready var good = $CanvasLayer/full/good
@onready var filter = $CanvasLayer/full/filter
@onready var not_filter = $CanvasLayer/full/filter/not_filter
@onready var particles = $CanvasLayer/full/filter/not_filter/CPUParticles2D
var finished = false
var vel = 6
var tween = null
var origin_pos = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var sweet_spot = randf_range(0.3, 0.5)
	var margin = (1-sweet_spot) * full.size.x
	good.size.x -= margin
	good.position.x += margin/3
	tween = get_tree().create_tween()
	tween.tween_property(not_filter, "size", Vector2(0,not_filter.size.y), 5)
	tween.tween_callback(_won)
	filter.position.x = good.position.x +1
	origin_pos = not_filter.size.x
	
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	var left_part = filter.position.x
	var right_part = left_part+filter.size.x
	if left_part < good.position.x:
		print("Die")
	elif right_part > good.position.x+good.size.x:
		print("Not smoking")
	var move_tween = get_tree().create_tween()
	var vec = filter.position
	if Input.is_action_pressed("slots"): vec.x-=vel
	else: vec.x+=vel/2.0
	move_tween.tween_property(filter,"position", vec,delta)
	particles.position.x = not_filter.size.x
	

func _won():
	print("Won")
