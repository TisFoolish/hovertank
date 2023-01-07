extends Node3D

const bullet = preload("res://Scenes/Weapons/Boo let.tscn")

var weapon_state : bool = true

var gunsound


func _ready():
	gunsound = $GunFire

# Called when the node enters the scene tree for the first time.
func _process(delta):
	if(Input.is_action_pressed("fire_weapon")):
		$AnimationPlayer.play("fire")
		get_node("../vehicle_v2_tscn/barrels/barrel_spin").play("barrel_spin")
		
	else:
		$AnimationPlayer.stop(false)
	pass # Replace with function body.
	
	if(Input.is_action_just_released("fire_weapon")):
		get_node("../vehicle_v2_tscn/barrels/barrel_spin").play("barrel_spin_down")
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	if($AnimationPlayer.is_playing() == true):
#		match $AnimationPlayer.


	

func _on_timer_timeout():
	if(Input.is_action_pressed("fire_weapon") && weapon_state == true):
		var newBullet = bullet.instantiate()
		get_tree().get_root().add_child(newBullet)
		gunsound.play()
		newBullet.speed = 100
		newBullet.position = $BulletSpawnPoint.global_position
		newBullet.rotation = $BulletSpawnPoint.global_rotation
		newBullet.velocity = Vector3(-global_transform.basis.z)
		
		

