extends Node2D

var start = false
var ha = false
var exiting = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$SubViewportContainer/SubViewport.size = DisplayServer.window_get_size_with_decorations()
	pass # Replace with function body.


func _process(delta):
	if(start == true && $AnimationPlayer.current_animation_length == $AnimationPlayer.current_animation_position):
		get_tree().change_scene_to_file("res://Scenes/Levels/Base.tscn")
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

#Tried a workaround to fix the fact that the SVPs weren't stretching to fit the window,
#but ii nolonger works

#func res_workaround_hack(svp:SubViewport, correct_size:Vector2i):
#	for i in 3: # with one iteration, this fails up to 50% of the time 
#		await get_tree().process_frame
#		svp.size = correct_size



func _on_window_input_resolution_changed():
	var svp = $SubViewportContainer/SubViewport
	var mode = DisplayServer.window_get_mode()
	if (mode == 3 || mode == 4):
#		res_workaround_hack(svp, DisplayServer.window_get_size_with_decorations())
		svp.size = DisplayServer.window_get_size_with_decorations()
	else:
#		res_workaround_hack(svp, DisplayServer.window_get_size())
		svp.size = DisplayServer.window_get_size()

