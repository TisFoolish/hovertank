extends Node3D

const bullet = preload("res://Scenes/Weapons/Boo let.tscn")
const bulletSounds : Array[AudioStreamOggVorbis] = [
					preload("res://Assets/Audio/SoundFX/Gun 01.ogg"), 
					preload("res://Assets/Audio/SoundFX/Gun 02.ogg"),
					preload("res://Assets/Audio/SoundFX/Gun 03.ogg"),
					preload("res://Assets/Audio/SoundFX/Gun 04.ogg"),
					preload("res://Assets/Audio/SoundFX/Gun 05.ogg")]

var weapon_state : bool = true

var gunsound

var velocity : Vector3
var pre_pos : Vector3

func _ready():
	gunsound = $GunFire


func _process(delta):
	if(Input.is_action_pressed("fire_weapon")):
		$AnimationPlayer.play("fire")
		get_node("../vehicle_v2_tscn/barrels/barrel_spin").play("barrel_spin")

	else:
		$AnimationPlayer.stop(false)
	
	if(Input.is_action_just_released("fire_weapon")):
		get_node("../vehicle_v2_tscn/barrels/barrel_spin").play("barrel_spin_down")

func _physics_process(delta):
	velocity = global_position-pre_pos
	pre_pos = global_position

func _on_timer_timeout():
	if(Input.is_action_pressed("fire_weapon") && weapon_state == true):
		var newBullet = bullet.instantiate()
		get_tree().get_root().add_child(newBullet)
		
#        Tried making the gun use the gun sounds at random when firing, but it cuts off some of them
#        and doesn't sound very good. 
#        gunsound.stream = bulletSounds[randi_range(0,4)]

		gunsound.play()
		newBullet.speed = 100
		newBullet.position = $BulletSpawnPoint.global_position
		newBullet.rotation = $BulletSpawnPoint.global_rotation
		newBullet.velocity = Vector3(-global_transform.basis.z) + velocity
