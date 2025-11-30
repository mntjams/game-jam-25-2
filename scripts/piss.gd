extends Node2D

@onready var slider = $CanvasLayer/slider

var dir = 1
var interest_gained : float = 10
var finished_mini : bool = false
var sweet_spot = 0

var pushing_sfx_path: String = "res://assets/sounds/sfx/toilet-sfx/poop-pushing.mp3"
var poop_into_toilet_sfx_path: String = "res://assets/sounds/sfx/toilet-sfx/poop-into-toilet.mp3"
var relief_sfx_path: String = "res://assets/sounds/sfx/toilet-sfx/huh-relief.mp3"
var toilet_flush_sfx_path: String = "res://assets/sounds/sfx/toilet-sfx/toilet-flush.mp3"
var poop_on_floor_sfx_path: String = "res://assets/sounds/sfx/toilet-sfx/poop-on-floor.mp3"
var uhoh_sfx_path: String = "res://assets/sounds/sfx/toilet-sfx/uhoh.mp3"

var poop_pushing_player: AudioStreamPlayer

signal finished(success: bool, interest_gained : float)

func start():
	pass

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	poop_pushing_player = play_audio(pushing_sfx_path)
	sweet_spot = randf_range(0.2, 0.5)
	var margin = (1-sweet_spot) * slider.size.x
	var style = slider.get_theme_stylebox("slider")
	style.grow_begin = -margin/2
	style.grow_end = -margin/2

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	
			
		#TODO: fix sweet spot here
	
	if not finished_mini:
		if Input.is_action_just_pressed("slots"):
			var offset = ((1-sweet_spot)/2)*100
			if slider.value >= offset and slider.value <= 100-offset:
				won()
			else: lost()
			finished_mini = true
		var tween = get_tree().create_tween()
		var val = slider.value
		var vel = 2
		if val == slider.max_value or val == slider.min_value: dir*=-1
		tween.tween_property(slider,"value", val+dir*vel,delta)
		
func won():
	poop_pushing_player.stop()
	play_audio(poop_into_toilet_sfx_path).finished.connect(func():
		play_audio(relief_sfx_path).finished.connect(func():
			play_audio(toilet_flush_sfx_path).finished.connect(func():
				queue_free()
				emit_signal("finished",true,interest_gained)
			)
		)
	)
	
func lost():
	poop_pushing_player.stop()
	play_audio(poop_on_floor_sfx_path).finished.connect(func():
		play_audio(uhoh_sfx_path).finished.connect(func():
			emit_signal("finished",false,interest_gained)
			queue_free()
		)
	)

func play_audio(path_to_stream: String) -> AudioStreamPlayer:
	var player := AudioStreamPlayer.new()
	add_child(player)
	
	player.stream = load(path_to_stream)
	player.finished.connect(func():
		player.queue_free()
	)
	
	player.play()
	
	return player
