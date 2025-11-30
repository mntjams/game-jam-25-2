extends Node2D
@onready var pathf = $CanvasLayer/Path2D/PathFollow2D
@onready var left = $CanvasLayer/Path2D/left
@onready var right = $CanvasLayer/Path2D/right
@onready var tween = get_tree().create_tween()

var vel = 0.002
var press_vel = vel*30
var sweet_spot = 0
var lost = false
var won = false

signal finished(success: bool, interest_gained : float)

@onready var win_timer = $WinTimer
var lost_reward = -10
var win_reward = 10


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pathf.progress_ratio = 0.5
	sweet_spot = randf_range(0.25, 0.4)
	var margin = (1-sweet_spot)/2
	left.progress_ratio = margin
	right.progress_ratio = 1-margin
	var time = randf_range(4,5)
	win_timer.wait_time = time
	win_timer.start()
	tween.tween_property($CanvasLayer/ProgressBar, "value", 100, time)

func start():
	pass



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	if not lost and not won:
		if Input.is_action_just_pressed("left"):
			pathf.progress_ratio -= press_vel
		elif Input.is_action_just_pressed("right"):
			pathf.progress_ratio += press_vel
		elif pathf.progress_ratio >= 0.5 and pathf.progress_ratio <= 0.99:
			pathf.progress_ratio += vel
		elif pathf.progress_ratio < 0.5 and pathf.progress_ratio >= 0.01: pathf.progress_ratio -= vel
	
		if pathf.progress_ratio < left.progress_ratio or pathf.progress_ratio > right.progress_ratio:
			lost = true
			losing()
			
		

func losing():
	tween.stop()
	tween = get_tree().create_tween()
	if pathf.progress_ratio < left.progress_ratio:
		tween.tween_property(pathf, "progress_ratio", 0,1)
	else: tween.tween_property(pathf, "progress_ratio", 1,1)
	await tween.finished
	emit_signal("finished",false,lost_reward)
	queue_free()


func _on_win_timer_timeout():
	# TODO: win sound effect
	won = true
	emit_signal("finished",true,win_reward)
	queue_free()
