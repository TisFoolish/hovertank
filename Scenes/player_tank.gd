extends CharacterBody3D



@export var SPEED = 5.0
#Rotation Speed in ????
@export var ROTATION_SPEED = 0.01

@export var ACC = .1
const ANGULAR_ACC = .1
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta


	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
#	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
#	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
#	if direction:
#		velocity.x = direction.x * SPEED
#		velocity.z = direction.z * SPEED
#	else:
#		velocity.x = move_toward(velocity.x, 0, SPEED)
#		velocity.z = move_toward(velocity.z, 0, SPEED)

	var left_input_dir = Input.get_vector("left_hover_bank_left", "left_hover_bank_right", "left_hover_bank_forward", "left_hover_bank_backward")
	var right_input_dir = Input.get_vector("right_hover_bank_left", "right_hover_bank_right", "right_hover_bank_forward","right_hover_bank_backward")
	var combined_x = left_input_dir.x + right_input_dir.x
	var combined_y = left_input_dir.y + right_input_dir.y
	var combined_dir = (transform.basis * Vector3(combined_x, 0, combined_y)).normalized()
	var rotation_strength = left_input_dir.y + (right_input_dir.y * -1.0)
#	var rotation = 0.0
#	print_debug("Velocity: ", velocity, " Rotation: ", rotation)
	if(left_input_dir.length() == 0 && right_input_dir.length() == 0):

		velocity.x = move_toward(velocity.x, combined_dir.x * SPEED, ACC)
		velocity.z = move_toward(velocity.z, combined_dir.z * SPEED, ACC)
#		rotation.y = lerp_angle(rotation.y, rotation.y + left_input_dir.y + (right_input_dir.y * -1.0), delta*ROTATION_SPEED)
		rotation_strength = move_toward(rotation_strength, 0, ANGULAR_ACC)
		rotate_object_local(Vector3(Vector3.UP), ROTATION_SPEED * rotation_strength)
		transform = transform.orthonormalized()
	elif(left_input_dir.length() != 0 && right_input_dir.length() != 0):
		velocity.x = move_toward(velocity.x, combined_dir.x * SPEED, ACC)
		velocity.z = move_toward(velocity.z, combined_dir.z * SPEED, ACC)
#		velocity.x = combined_dir.x * SPEED
#		velocity.z = combined_dir.z * SPEED
#		rotation.y = lerp_angle(rotation.y, rotation.y + left_input_dir.y + (right_input_dir.y * -1.0), delta*ROTATION_SPEED)
		rotate_object_local(Vector3(Vector3.UP), ROTATION_SPEED * rotation_strength)
		transform = transform.orthonormalized()
	else:
		velocity.x = move_toward(velocity.x, 0, ACC)
		velocity.z = move_toward(velocity.z, 0, ACC)
#		rotation.y = lerp_angle(rotation.y, rotation.y + left_input_dir.y + (right_input_dir.y * -1.0), delta*ROTATION_SPEED)
		rotate_object_local(Vector3(Vector3.UP), ROTATION_SPEED * rotation_strength)
		transform = transform.orthonormalized()
		
	move_and_slide()
