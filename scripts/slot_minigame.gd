extends Node2D

signal finished(success: bool, interest_gained : float)

var interest_gained : float = 30
var shift : float = 6
var down_speed : float = 0.2
@onready var slider = $CanvasLayer/slot
var ended = false

const spin_sfx_path: String = "res://assets/sounds/sfx/slots/slot-machine-spin.mp3"
const slot_win_sfx_path: String = "res://assets/sounds/sfx/slots/slot-machine-win.mp3"
var spin_sfx_player: AudioStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spin_sfx_player = play_audio(spin_sfx_path)
	slider.value = randf_range(0.3, 0.5)*100

func start():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	
	if not ended:
		var tween = get_tree().create_tween()
		if Input.is_action_just_pressed("slots"):
			tween.tween_property(slider,"value", slider.value+shift,delta)
			if slider.value+shift >= 99:
				ended = true
				won()
		else: tween.tween_property(slider,"value", slider.value-down_speed,delta)

func won():
	# print("won")
	spin_sfx_player.stop()
	play_audio(slot_win_sfx_path).finished.connect(func():
		emit_signal("finished", true, interest_gained)
		queue_free()
	)
	$CanvasLayer/slot/CPUParticles2D.emitting = true
	#await get_tree().create_timer(1).timeout
	
func play_audio(path_to_stream: String) -> AudioStreamPlayer:
	var player := AudioStreamPlayer.new()
	add_child(player)
	
	player.stream = load(path_to_stream)
	player.finished.connect(func():
		player.queue_free()
	)
	
	player.play()
	
	return player
