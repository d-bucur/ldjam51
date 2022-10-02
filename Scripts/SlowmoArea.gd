extends Area2D

export var slowmo_scale = 0.4

signal activate_slowmo(scale)
signal deactivate_slowmo


func _on_SlowmoArea_body_entered(body):
	Engine.time_scale = slowmo_scale
	$Sprite.show()
	emit_signal("activate_slowmo", slowmo_scale)


func _on_SlowmoArea_body_exited(body):
	Engine.time_scale = 1
	$Sprite.hide()
	emit_signal("deactivate_slowmo")
