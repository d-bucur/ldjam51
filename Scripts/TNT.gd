extends RigidBody2D

signal projectile_hit
signal lance_triggered

export(PackedScene) var explosion_template
export var time_to_activate = 1

var is_active = false

func _ready():
	yield(get_tree().create_timer(time_to_activate), "timeout")
	is_active = true

func explode():
	if !is_active:
		return
	
	queue_free()
	var explosion: Node2D = explosion_template.instance()
	explosion.position = position
	get_parent().add_child(explosion)

func _on_TNT_projectile_hit():
	explode()


func _on_TNT_lance_triggered():
	explode()
