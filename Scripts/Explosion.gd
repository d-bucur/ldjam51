extends Area2D


func _on_Timer_timeout():
	queue_free()


func _on_Explosion_body_entered(body):
	print("Explosion hit something")
	body.emit_signal("projectile_hit")
