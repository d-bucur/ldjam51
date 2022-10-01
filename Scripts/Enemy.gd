extends RigidBody2D

export(PackedScene) var projectile_template
export var projectile_speed = 15000
export var projectile_offset = 100

signal enemy_killed
signal projectile_hit

func shoot():
	print("Shooting")
	var projectile: Node2D = projectile_template.instance()
	projectile.rotation = rotation
	projectile.position = position + Vector2(0, -projectile_offset).rotated(rotation)
	var velocity = Vector2(0, -projectile_speed)
	projectile.linear_velocity = velocity.rotated(rotation)
	get_parent().add_child(projectile)

# TODO replace with signal?
func on_lance_triggered():
	shoot()
	
func kill():
	emit_signal("enemy_killed")
	queue_free()

func _on_Enemy_projectile_hit():
	kill()
