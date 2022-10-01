extends KinematicBody2D

export(PackedScene) var projectile_template
export var projectile_speed = 15000
export var projectile_offset = 100

signal enemy_killed
signal projectile_hit
signal lance_triggered

var player

func shoot():
	print("Shooting")
	var projectile: Node2D = projectile_template.instance()
	projectile.rotation = rotation
	projectile.position = position + Vector2(projectile_offset, 0).rotated(rotation)
	var velocity = Vector2(projectile_speed, 0)
	projectile.linear_velocity = velocity.rotated(rotation)
	get_parent().add_child(projectile)
	
	look_at(player.position)
	
func kill():
	emit_signal("enemy_killed")
	queue_free()

func _on_Enemy_projectile_hit():
	kill()

func set_player(player_obj):
	player = player_obj


func _on_Enemy_lance_triggered():
	shoot()
