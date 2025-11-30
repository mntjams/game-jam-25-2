extends Node2D
@onready var pathf = $CanvasLayer/Path2D/PathFollow2D
var vel = 0.002
var press_vel = vel*30
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pathf.progress_ratio = 0.5

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("left"):
		pathf.progress_ratio -= press_vel
	elif Input.is_action_just_pressed("right"):
		pathf.progress_ratio += press_vel
	elif pathf.progress_ratio >= 0.5 and pathf.progress_ratio <= 0.99:
		pathf.progress_ratio += vel
	elif pathf.progress_ratio < 0.5 and pathf.progress_ratio >= 0.01: pathf.progress_ratio -= vel
