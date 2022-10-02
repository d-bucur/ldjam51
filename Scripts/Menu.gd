extends Control

var instructions = false

func _on_StartButton_pressed():
	if instructions:
		get_tree().change_scene("res://Scenes/Main.tscn")
	else:
		instructions = true
		$Instructions.show()
		$Credits.hide()
