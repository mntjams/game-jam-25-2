extends CharacterBody2D
class_name Npc

@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D

signal ready_for_room(npc: Npc, from_room: Room) # signal the room manager to give us a room

var current_room: Room = null
var current_slot: Slot = null
@export var movement_speed: float = 50.0

var work_time_base : float = 5
var working : bool = false

# --- NPC Movement ---------------------------------------------------------

# set npc to go to the given Room and Slot
func go_to_slot(room: Room, slot: Slot) -> void:
	current_room = room
	current_slot = slot
	#print("--- NPC:",self,"---")
	#print("Going to room:",room)
	#print("Going to slot:",slot)
	_navigate_to(slot.global_position)

# set the destination of my navigation agent
func _navigate_to(destination: Vector2) -> void:
	navigation_agent_2d.target_position = destination

func _physics_process(_delta: float) -> void:
	# No target slot → do not move
	if current_slot == null or working:
		velocity = Vector2.ZERO
		return

	# If path is finished, we are at (or very near) the slot
	if navigation_agent_2d.is_navigation_finished() and not working:
		_on_reached_slot()
		return

	var current_agent_position: Vector2 = global_position
	var next_path_position: Vector2 = navigation_agent_2d.get_next_path_position()

	var new_velocity: Vector2 = current_agent_position.direction_to(next_path_position) * movement_speed
	velocity = new_velocity
	move_and_slide()

# --- NPC Lifecycle (handling work at locations) - arrive, work, leave, request ------------------------

func _ready() -> void:
	#print(self,": I am ready")
	emit_signal("ready_for_room", self, null)

# what the npc should do when on the slot
func _on_reached_slot() -> void:
	velocity = Vector2.ZERO
	working = true
	# NPC is at the slot. Do room-specific work here.
	# When the work is finished, call `on_done_in_room()`.
	var work_time = work_time_base + randf_range(-2.5,2.5)
	#print(self,"started working for ",work_time," seconds")
	await get_tree().create_timer(work_time).timeout
	working = false
	#print(self,"stopped working")
	on_done_in_room()
	

# when npc leaves the slot
func leave_current_slot() -> void:
	if current_room != null and current_slot != null:
		current_room.release_slot(current_slot)
	current_room = null
	current_slot = null

# send the signal that we're done in the room
func on_done_in_room() -> void:
	var old_room: Room = current_room
	leave_current_slot()
	#print(self,"I am done in this room")
	emit_signal("ready_for_room", self, old_room)
