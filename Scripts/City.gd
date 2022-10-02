extends KinematicBody2D


signal projectile_hit
signal player_killed


func _on_City_projectile_hit():
#	queue_free()
	print("city hit")
	emit_signal("player_killed", self)
