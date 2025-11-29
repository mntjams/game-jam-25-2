extends CharacterBody2D

var goal = null
var finished = false
@onready var nav_agent = $NavigationAgent2D
var movement_speed: float = 50
@onready var timer = get_tree().create_timer(1)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if goal and timer.time_left > 0:
		var next_path_position: Vector2 = nav_agent.get_next_path_position()
		var new_velocity: Vector2 = global_position.direction_to(next_path_position) * movement_speed
		
		if nav_agent.is_navigation_finished() and !finished:
			timer = get_tree().create_timer(1)
			finished = true
		
		velocity = new_velocity
		move_and_slide()
		
	else:
		finished = false
		if goal: GM.free_locations.append(goal)
		goal = GM.free_locations.pop_front()
		nav_agent.target_position = goal
		timer = get_tree().create_timer(5)
		
