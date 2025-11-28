extends CharacterBody2D

@export var speed = 400

# animation values
var sprite_motion : String = "idle";
var sprite_dir : String = "down";
var flip_sprite : bool = false

# set variables for animation
func set_animation_vals(input_direction : Vector2):
	if input_direction.y > 0:
		sprite_dir = "down"
	elif input_direction.y < 0:
		sprite_dir = "up"
	elif input_direction.x != 0:
		sprite_dir = "side"
		
	if input_direction == Vector2.ZERO:
		sprite_motion = "idle"
	else:
		sprite_motion = "walk"

	if input_direction.x < 0:
		flip_sprite = false
	elif input_direction.x > 0:
		flip_sprite = true

# read input
func get_input():	
	var input_direction = Input.get_vector("left", "right", "up", "down")
	set_animation_vals(input_direction)
	velocity = input_direction * speed

# animate the character
func animate():
	var animation_to_play = sprite_motion + "_" + sprite_dir
	$AnimatedSprite2D.flip_h = flip_sprite
	$AnimatedSprite2D.play(animation_to_play)
	

func _physics_process(delta):
	get_input()
	move_and_slide()
	animate()
