extends Node2D

var start = false
var ha = false
var exiting = false


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _process(delta):
	if(start == true && $AnimationPlayer.current_animation_length == $AnimationPlayer.current_animation_position):
		get_tree().change_scene_to_file("res://Scenes/Base.tscn")
	elif(exiting == true && $AnimationPlayer.current_animation_length == $AnimationPlayer.current_animation_position):
		get_tree().quit() 
	pass


func _on_Start_pressed():

	if(exiting == false && ha == false):
		start = true
		$AnimationPlayer.play("FadeOut")


func _on_Options_pressed():
	if(ha == false):
		ha = true
		$AnimationPlayer.play("ha")



func _on_Exit_pressed():
	if(exiting == false && ha == false):
		exiting = true
		$AnimationPlayer.play("FadeOut")
	

func _on_animation_player_animation_finished(anim_name):
	if(anim_name == "ha"):
		ha = false
		$AnimationPlayer.stop(true)





func _on_window_input_resolution_changed():
	$SubViewportContainer/SubViewport.size = DisplayServer.window_get_size_with_decorations()
	pass # Replace with function body.
