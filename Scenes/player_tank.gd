extends CharacterBody3D



@export var MAX_SPEED = 20
#Rotation Speed in ????
@export var MAX_ROTATION_SPEED = 0.01

@export var ACCLERATION = .8
@export var ANGULAR_ACC = .08
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var rotation_strength = 0

func _physics_process(delta):
#	print_debug("### RL VELOCITY:", velocity)
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta


	var left_input_dir = Input.get_vector("left_hover_bank_left", "left_hover_bank_right", "left_hover_bank_forward", "left_hover_bank_backward")
	var right_input_dir = Input.get_vector("right_hover_bank_left", "right_hover_bank_right", "right_hover_bank_forward","right_hover_bank_backward")
	var combined_x = left_input_dir.x + right_input_dir.x
	var combined_y = left_input_dir.y + right_input_dir.y
	print_debug("### RL Combined X: ", combined_x, " Y: " ,combined_y)
#	print_debug("### RL COmbined Y: ", combined_y)

	var combined_velocity = (transform.basis * Vector3(combined_x, 0, combined_y)).normalized()
#	print_debug("### Combined Velocity: ", combined_velocity)
	
	rotation_strength = move_toward(rotation_strength, left_input_dir.y + (right_input_dir.y * -1.0), ANGULAR_ACC)

	if((left_input_dir.length() == 0 && right_input_dir.length() == 0)):
		calculate_velocity(transform.basis * Vector3(0,0,0))
	elif((left_input_dir.length() != 0 && right_input_dir.length() != 0)):
		calculate_velocity(combined_velocity)
	else:
		#Zero out velocity if only one input is given
		calculate_velocity(transform.basis * Vector3(0,0,0))
	move_and_slide()

#Combined Dir is for VELOCITY ONLY
func calculate_velocity(combined_velocity):
	velocity.x = move_toward(velocity.x, combined_velocity.x * MAX_SPEED, ACCLERATION)
	velocity.z = move_toward(velocity.z, combined_velocity.z * MAX_SPEED, ACCLERATION)
	if(rotation_strength != 0.0):
		rotate_object_local(Vector3(Vector3.UP), rotation_strength * MAX_ROTATION_SPEED)
		transform = transform.orthonormalized()
