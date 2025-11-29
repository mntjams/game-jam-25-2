extends CharacterBody2D

class_name Player

@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D
var women_in_sight : Array[InteractableWoman] = []
var movement_speed: float = 1000

signal woman_entered_sight
signal no_woman_in_sight

var is_interacting = false

# --- Woman interaction ---
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and not is_interacting: # "interact" bound to E
		if women_in_sight.size() == 0:
			print(self,"no women here")
		elif women_in_sight.size() == 1:	
			if women_in_sight[0].is_working():
				emit_signal("no_woman_in_sight")
				start_interaction()
		elif women_in_sight.size() > 1:
			print(self,"whooops")

func finish_interaction():
	is_interacting = false

func start_interaction():
		var woman : InteractableWoman = women_in_sight[0]
		woman.start_interaction(self)
		is_interacting = true
		print(self,"hey girl whatsup")


# --- Navigation ---
func _physics_process(delta: float) -> void:
	if not is_interacting:
		velocity = 60*delta*movement_speed*Vector2(Input.get_action_strength("right")-Input.get_action_strength("left"), Input.get_action_strength("down")-Input.get_action_strength("up")).normalized()
		#print(velocity)
		move_and_slide()
	
# --- Woman in sight tracking ---
func _ready() -> void:
	for woman in get_tree().get_nodes_in_group("NPCs"):
		woman.connect("approached_by_player", _on_approach)
		woman.connect("player_left", _on_leave)
		woman.connect("started_working",_on_woman_started_working)

func _on_woman_started_working(woman : Npc):
	#print(self,"some woman started working")
	if woman in women_in_sight:
		emit_signal("woman_entered_sight")

func _on_approach(woman : InteractableWoman, is_working : bool):
	women_in_sight.append(woman)
	if is_working:
		#print(self,"ENTERING",women_in_sight)
		emit_signal("woman_entered_sight")
	
func _on_leave(woman : InteractableWoman):
	var where = women_in_sight.find(woman)
	if where == -1:
		return
	women_in_sight.remove_at(where)
	#print(self,"LEEAVING",women_in_sight)
	if len(women_in_sight) == 0:
		emit_signal("no_woman_in_sight")
