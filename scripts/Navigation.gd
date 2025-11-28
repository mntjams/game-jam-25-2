extends CharacterBody2D

@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D

var movement_speed: float = 50

func _physics_process(delta: float) -> void:
	var mouse_position: Vector2 = get_global_mouse_position()
	navigate_to(mouse_position)
	
func navigate_to(destination: Vector2):
	navigation_agent_2d.target_position = destination
	
	var current_agent_position: Vector2 = global_position
	var next_path_position: Vector2 = navigation_agent_2d.get_next_path_position()
	var new_velocity: Vector2 = current_agent_position.direction_to(next_path_position) * movement_speed
	
	if navigation_agent_2d.is_navigation_finished():
		return
	
	velocity = new_velocity
	move_and_slide()
