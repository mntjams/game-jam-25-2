extends Node2D
@onready var full = $CanvasLayer/full
@onready var good = $CanvasLayer/full/good
@onready var filter = $CanvasLayer/full/filter
@onready var not_filter = $CanvasLayer/full/filter/not_filter
@onready var particles = $CanvasLayer/full/filter/not_filter/CPUParticles2D
var finished_game = false
var vel = 30
var tween = null
var origin_pos = 0
# Called when the node enters the scene tree for the first time.

signal finished(success: bool, interest_gained : float)

var interest_gained : float = 10.0

func start():
	pass

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
		# print("Die")
		_lost()
	elif right_part > good.position.x+good.size.x:
		# print("Not smoking")
		tween.pause()
	elif not tween.is_running() and not finished_game:
		tween.play()
	
	var pos = filter.position
	if Input.is_action_just_pressed("slots"): pos.x-=vel
	else:
		pos.x+=vel/15.0
		if right_part >= full.size.x:
				return
	var move_tween = get_tree().create_tween()
	move_tween.tween_property(filter,"position", pos, delta)
	particles.position.x = not_filter.size.x

func _won():
	finished_game = true
	# print("Won")
	emit_signal("finished", true, interest_gained)
	queue_free()
	
func _lost():
	finished_game = true
	# print("Lost")
	emit_signal("finished", false, interest_gained)
	queue_free()
	
