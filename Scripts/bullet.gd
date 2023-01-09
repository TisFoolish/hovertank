extends CharacterBody3D

var velc : Vector3 = Vector3(0,0,0)
var speed : float = 10

func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var collision : KinematicCollision3D = move_and_collide(velocity * delta * speed, false, 0.001, true, 1)
	if collision:
		var collider = collision.get_collider()
		if collider.has_method("targetdie"):
			collider.targetdie()
		queue_free()


func _on_death_timer_timeout():
	queue_free()
