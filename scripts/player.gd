extends CharacterBody2D

@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D
var women_in_sight : Array[InteractableWoman] = []
var movement_speed: float = 1000

signal woman_entered_sight
signal no_woman_in_sight

# --- Navigation ---
func _physics_process(delta: float) -> void:
	velocity = 60*delta*movement_speed*Vector2(Input.get_action_strength("right")-Input.get_action_strength("left"), Input.get_action_strength("down")-Input.get_action_strength("up")).normalized()
	print(velocity)
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
