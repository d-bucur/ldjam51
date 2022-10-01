extends RigidBody2D



func _on_Projectile_body_entered(body):
	print_debug("Projectile hit %s" % body)
	body.emit_signal("projectile_hit")
	queue_free()
