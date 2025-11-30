extends Control

var normalization = 32
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$HUD/SFXSlider.value = AudioServer.get_bus_volume_linear(0)*100


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("settings") and get_tree().current_scene.name != "MainMenu":
		$HUD.visible = !$HUD.visible
		get_tree().paused = !get_tree().paused


func _on_sfx_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_linear(0, value/100)
