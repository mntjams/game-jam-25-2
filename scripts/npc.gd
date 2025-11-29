extends CharacterBody2D
class_name Npc

@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D

signal ready_for_room(npc: Npc, from_room: Room) # signal the room manager to give us a room

var current_room: Room = null
var current_slot: Slot = null
@export var movement_speed: float = 500

var work_time_base : float = 5.0
var working : bool = false

@onready var stuck_timer: Timer = $StuckTimer
@export var stuck_timeout: float = 5      # seconds before we assume stuck

# --- NPC Movement ---------------------------------------------------------

# set npc to go to the given Room and Slot
func go_to_slot(room: Room, slot: Slot) -> void:
	current_room = room
	current_slot = slot
	#print("--- NPC:",self,"---")
	#print("Going to room:",room)
	#print("Going to slot:",slot)
	_navigate_to(slot.global_position)
	_restart_stuck_timer()

# set the destination of my navigation agent
func _navigate_to(destination: Vector2) -> void:
	navigation_agent_2d.target_position = destination

func _physics_process(_delta: float) -> void:
	#print(self,"stuck timer",stuck_timer.time_left)
	
	# No target slot → do not move
	if current_slot == null or working:
		velocity = Vector2.ZERO
		return

	# If path is finished, we are at (or very near) the slot
	if navigation_agent_2d.is_navigation_finished() and not working:
		_stop_stuck_timer()
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
	_init_stuck_timer()

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
	
func is_working():
	return working

# --- STUCK HANDLING ---

# initialize the stuck timer
func _init_stuck_timer():
	stuck_timer.wait_time = stuck_timeout
	stuck_timer.one_shot = true
	stuck_timer.timeout.connect(_on_stuck_timeout)
	_restart_stuck_timer()

func _on_stuck_timeout() -> void:
	# If we already reached the destination, ignore.
	if navigation_agent_2d.is_navigation_finished():
		return

	#print(self," Oh deer, I am stuck. Let's go some other way.")

	# Remember which room we were in.
	var old_room: Room = current_room

	# Free current slot and clear current_room/current_slot
	leave_current_slot()

	# Ask RoomManager for a new room/slot, excluding the previous one.
	emit_signal("ready_for_room", self, old_room)

func _restart_stuck_timer() -> void:
	stuck_timer.stop()
	stuck_timer.start()

func _stop_stuck_timer() -> void:
	stuck_timer.stop()
