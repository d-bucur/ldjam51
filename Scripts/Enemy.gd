extends RigidBody2D

export(PackedScene) var projectile_template
export var projectile_speed = 15000
export var projectile_offset = 100


func shoot():
	print("Shooting")
	var projectile: Node2D = projectile_template.instance()
	projectile.rotation = rotation
	projectile.position = position + Vector2(0, -projectile_offset).rotated(rotation)
	var velocity = Vector2(0, -projectile_speed)
	projectile.linear_velocity = velocity.rotated(rotation)
	get_parent().add_child(projectile)

func on_lance_triggered():
	shoot()
