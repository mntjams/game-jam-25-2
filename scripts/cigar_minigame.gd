extends Node2D
@onready var full = $CanvasLayer/full
@onready var good = $CanvasLayer/full/good
@onready var filter = $CanvasLayer/full/filter
@onready var not_filter = $CanvasLayer/full/filter/not_filter
@onready var particles = $CanvasLayer/full/filter/not_filter/CPUParticles2D
@onready var label = $CanvasLayer/LabelLabel
var finished_game = false
var vel = 45
var tween = null
var origin_pos = 0
# Called when the node enters the scene tree for the first time.

const lighter_sfx_path: String = "res://assets/sounds/sfx/smoking/lighter.mp3"
const burning_sfx_path: String = "res://assets/sounds/sfx/smoking/burning-cig.mp3"
const exhale_sfx_path: String = "res://assets/sounds/sfx/smoking/smoke-exhale.mp3"
const cough_sfx_path: String = "res://assets/sounds/sfx/smoking/cough.mp3"
var burning_sfx_player: AudioStreamPlayer

signal finished(success: bool, interest_gained : float)

var interest_gained : float = 30
var interest_lost : float = -10

func start():
	pass

func _ready() -> void:
	start_audio()
	
	var sweet_spot = randf_range(0.3, 0.5)
	var margin = (1-sweet_spot) * full.size.x
	good.size.x -= margin
	good.position.x += margin/3
	tween = get_tree().create_tween()
	tween.tween_property(not_filter, "size", Vector2(49,not_filter.size.y), 5)
	tween.tween_callback(_won)
	filter.position.x = good.position.x +1
	origin_pos = not_filter.size.x
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if not finished_game:
		var left_part = filter.position.x
		var right_part = left_part+filter.size.x
		if left_part < good.position.x and not finished_game:
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
			pos.x+=vel/20.0
			if right_part >= full.size.x:
					return
		var move_tween = get_tree().create_tween()
		move_tween.tween_property(filter,"position", pos, delta)
		particles.position.x = not_filter.size.x

func _won():
	finished_game = true
	# print("Won")
	
	burning_sfx_player.stop()
	burning_sfx_player.queue_free()
	
	var player: AudioStreamPlayer = play_audio(exhale_sfx_path)
	player.finished.connect(func():
		emit_signal("finished", true, interest_gained)
		queue_free()
	)
	
func _lost():
	full.visible = false
	label.visible = false
	finished_game = true
	play_audio(cough_sfx_path).finished.connect(func():
		emit_signal("finished", true, interest_lost)
		queue_free()
	)
	# print("Lost")

func play_audio(path_to_stream: String) -> AudioStreamPlayer:
	var player := AudioStreamPlayer.new()
	add_child(player)
	
	player.stream = load(path_to_stream)
	player.finished.connect(func():
		player.queue_free()
	)
	
	player.play()
	
	return player
	
func start_audio() -> void:
	var player: AudioStreamPlayer = play_audio(lighter_sfx_path)
	player.finished.connect(func():
		burning_sfx_player = play_audio(burning_sfx_path)
	)
