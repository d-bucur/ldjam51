extends RigidBody2D


signal projectile_hit
signal player_killed


func _ready():
	$CollisionShape2D.disabled = true
	yield(get_tree().create_timer(2), "timeout")
	$CollisionShape2D.disabled = false
	$Sprite.animation = "default"


func _on_City_projectile_hit():
#	queue_free()
	print("city hit")
	emit_signal("player_killed", self)
