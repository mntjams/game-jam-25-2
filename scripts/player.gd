extends CharacterBody2D

@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D
var women_in_sight : Array[InteractableWoman] = []
var movement_speed: float = 200

signal woman_entered_sight
signal no_woman_in_sight

# --- Navigation ---
func _physics_process(_delta: float) -> void:
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

# --- Woman in sight tracking ---
func _ready() -> void:
	for woman in get_tree().get_nodes_in_group("NPCs"):
		woman.connect("approached_by_player", _on_approach)
		woman.connect("player_left", _on_leave)

func _on_approach(woman : InteractableWoman):
	women_in_sight.append(woman)
	print(women_in_sight)
	emit_signal("woman_entered_sight")
	
func _on_leave(woman : InteractableWoman):
	var where = women_in_sight.find(woman)
	women_in_sight.remove_at(where)
	print(women_in_sight)
	if len(women_in_sight) == 0:
		emit_signal("no_woman_in_sight")
