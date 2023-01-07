extends Node

var windowmode = DisplayServer.window_get_mode() 

signal resolution_changed()

func _process(delta):
	if(Input.is_action_just_pressed("escape")):
		get_tree().quit() 
	if(Input.is_action_just_pressed("toggle_fullscreen")):
		if(windowmode == 0):
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			windowmode = DisplayServer.window_get_mode()
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			windowmode = DisplayServer.window_get_mode()
		emit_signal("resolution_changed")
