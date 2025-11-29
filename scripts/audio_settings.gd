extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("settings"):
		$HUD.visible = !$HUD.visible
