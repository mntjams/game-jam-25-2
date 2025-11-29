extends Control

@export var successes_needed: int = 3
@onready var time_to_hit_event: Timer = $TimeToHitEvent
@onready var time_between_events: Timer = $TimeBetweenEvents
@onready var label: Label = $LabelControl/Label

var sound_effects: Array[AudioStreamMP3]
var sound_path: String = "res://assets/sounds/sfx/quicktime-event-minigame/"

var current_key: Key
var current_letter: String = 'x'
var key_already_pressed: bool = false
var key_map: Array = [
	[KEY_W, "W"],
	[KEY_A, "A"],
	[KEY_S, "S"],
	[KEY_D, "D"],
	[KEY_Q, "Q"],
	[KEY_E, "E"],

]

signal finished(success: bool)

func start() -> void:
	sound_effects = load_sounds(sound_path)
	print(sound_effects)
	start_event()
	
func _process(_delta: float) -> void:
	if Input.is_key_pressed(current_key) and not key_already_pressed:
		key_already_pressed = true
		play_random_sound()
		successes_needed -= 1
		print("Correct key was pressed! Need this many succ: " + str(successes_needed))
		time_to_hit_event.stop()
		if successes_needed == 0:
			emit_signal("finished", true)
			print("quicktime event finished")
			queue_free()
			return
		_on_time_to_hit_event_timeout()

func start_event() -> void:
	print("starting event")
	
	key_already_pressed = false
	
	var key_and_char = get_random_wasd()
	
	current_key = key_and_char[0]
	current_letter = key_and_char[1]
	label.text = current_letter
	label.visible = true

	
	time_to_hit_event.start()

func get_random_wasd():
	var key_and_char = key_map[randi() % key_map.size()]
	return key_and_char
	
func load_sounds(path: String) -> Array[AudioStreamMP3]:
	var sfxs : Array[AudioStreamMP3] = []
	
	var dir := DirAccess.open(path)

	if dir == null:
		push_error("Cannot open directory: " + path)
		return sfxs

	dir.list_dir_begin()

	while true:
		var file := dir.get_next()
		if file == "":
			break
		if dir.current_is_dir():
			continue
		
		if file.ends_with("mp3"):
			var stream := load(path + file)
			if stream:
				sfxs.append(stream)

	dir.list_dir_end()
	return sfxs

func get_random_sound() -> AudioStreamMP3:
	return sound_effects[randi() % sound_effects.size()]

func play_random_sound() -> void:
	var player := AudioStreamPlayer.new()
	add_child(player)

	player.stream = get_random_sound()
	player.play()

	player.finished.connect(func():
		player.queue_free()
	)
	
func _on_time_to_hit_event_timeout() -> void:
	print("Time to hit event timeout!")
	label.visible = false
	time_between_events.start()

func _on_time_between_events_timeout() -> void:
	start_event()
