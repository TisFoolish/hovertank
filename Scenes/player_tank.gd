extends CharacterBody3D



@export var MAX_SPEED = 100
#Rotation Speed in ????
@export var MAX_ROTATION_SPEED = 0.05

@export var ACCLERATION = 60
@export var MAX_ANGULAR_ACC = .25
# Get the gravity from the project settings to be synced with RigidBody nodes.

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var rotation_strength = 0
var engineHum

func _ready():
	engineHum = $AudioStreamPlayer3D
	engineHum.play()
	
func _process(delta):
	if(Input.is_action_pressed("escape")):
		get_tree().quit() 

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



	var combined_velocity = (transform.basis * Vector3(combined_x, velocity.y, combined_y)).normalized()
	var total_angular_acc = (MAX_ANGULAR_ACC/2 * abs(left_input_dir.y)) + (MAX_ANGULAR_ACC/2 * abs(right_input_dir.y))
	if (total_angular_acc == 0):
		total_angular_acc = MAX_ANGULAR_ACC
	rotation_strength = move_toward(rotation_strength, (left_input_dir.y + (right_input_dir.y * -1.0)) * MAX_ROTATION_SPEED, total_angular_acc * delta)
	
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
		if(Input.is_action_pressed("left_hover_bank_left") || 
				Input.is_action_pressed("left_hover_bank_right") || 
				Input.is_action_pressed("right_hover_bank_left") || 
				Input.is_action_pressed("right_hover_bank_right")):
			combined_velocity.x = combined_velocity.x/2
			
		calculate_velocity(combined_velocity,delta)
	
	move_and_slide()


func calculate_velocity(combined_velocity,delta):
	velocity = velocity.move_toward(combined_velocity*MAX_SPEED, delta * ACCLERATION)
	engineHum.pitch_scale = move_toward(engineHum.pitch_scale, 1 + combined_velocity.normalized().length(), delta) 
#	print("Velocity X: ", velocity.x)
#	print("Velocity Z: ", velocity.z)
	if(rotation_strength != 0.0):
		rotate_object_local(Vector3(Vector3.UP), rotation_strength)
		transform = transform.orthonormalized()
