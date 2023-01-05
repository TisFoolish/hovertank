extends CharacterBody3D



@export var MAX_SPEED = 20
#Rotation Speed in ????
@export var MAX_ROTATION_SPEED = 0.01

@export var ACCLERATION = 20
@export var ANGULAR_ACC = .08
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var rotation_strength = 0

func _physics_process(delta):
#	print_debug("### RL VELOCITY:", velocity)
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta


	var left_input_dir = Input.get_vector("left_hover_bank_left", "left_hover_bank_right", "left_hover_bank_forward", "left_hover_bank_backward") * 0.5
	var right_input_dir = Input.get_vector("right_hover_bank_left", "right_hover_bank_right", "right_hover_bank_forward","right_hover_bank_backward") * 0.5
	var combined_x = left_input_dir.x + right_input_dir.x
	var combined_y = left_input_dir.y + right_input_dir.y
#	print_debug("### RL Combined X: ", combined_x, " Y: " ,combined_y)
#	print_debug("### RL COmbined Y: ", combined_y)



	var combined_velocity = (transform.basis * Vector3(combined_x, 0, combined_y)).normalized()
#	print_debug("### Combined Velocity: ", combined_velocity)
	
	rotation_strength = move_toward(rotation_strength, left_input_dir.y + (right_input_dir.y * -1.0), ANGULAR_ACC)
	
	#If both inputs are 0 or if both inputs are not Zero (meaning the player is pressing buttons on both sides, not just one side
	# 	calculate velocity as normal
	#If only one set of inputs is not zero, then move into else. If only forward and back on one side is input, set velocity to zero
	# 	and rotate along center axis
	#If left and right on one input is being pressed, then zero out forward and back
	if((left_input_dir.length() == 0 && right_input_dir.length() == 0) || (left_input_dir.length() != 0 && right_input_dir.length() != 0)):
		calculate_velocity(combined_velocity,delta)
	else:
		
		if(Input.is_action_pressed("left_hover_bank_forward") || 
				Input.is_action_pressed("left_hover_bank_backward") || 
				Input.is_action_pressed("right_hover_bank_forward") || 
				Input.is_action_pressed("right_hover_bank_backward")):
			combined_velocity.x = 0
			combined_velocity.z = 0
		
		calculate_velocity(combined_velocity,delta)
	move_and_slide()


func calculate_velocity(combined_velocity,delta):
	velocity = velocity.move_toward(combined_velocity*MAX_SPEED, delta * ACCLERATION)
	print("Velocity X: ", velocity.x)
	print("Velocity Z: ", velocity.z)
	if(rotation_strength != 0.0):
		rotate_object_local(Vector3(Vector3.UP), rotation_strength * MAX_ROTATION_SPEED)
		transform = transform.orthonormalized()
