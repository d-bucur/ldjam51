extends RigidBody2D


signal projectile_hit
signal player_killed
signal lance_triggered

var last_activation


func _ready():
	$CollisionShape2D.disabled = true
	yield(get_tree().create_timer(2), "timeout")
	$CollisionShape2D.disabled = false
	$Sprite.animation = "default"


func _on_City_projectile_hit():
#	queue_free()
	print("city hit")
	emit_signal("player_killed", self)


func _on_City_lance_triggered():
	# add cooldown to prevent abuse
	if last_activation == null or (Time.get_ticks_msec() - last_activation >= 5000):
		last_activation = Time.get_ticks_msec()
		$"/root/Main".emit_signal("add_score", global_position)  # TODO ugly hack
