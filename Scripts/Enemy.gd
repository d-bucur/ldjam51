extends KinematicBody2D

export(PackedScene) var projectile_template
export(PackedScene) var powerup_template
export var projectile_speed = 15000
export var projectile_offset = 100
export var powerup_chance = 1.0

signal enemy_killed
signal projectile_hit
signal lance_triggered

var player: KinematicBody2D
var tween: SceneTreeTween
var ready_to_shoot = false

func _ready():
	yield(get_tree().create_timer(2), "timeout")
	ready_to_shoot = true

func shoot():
	if !ready_to_shoot:
		return
		
#	print("Shooting")
	var projectile: Node2D = projectile_template.instance()
	projectile.rotation = rotation
	projectile.position = position + Vector2(projectile_offset, 0).rotated(rotation)
	var velocity = Vector2(projectile_speed, 0)
	projectile.linear_velocity = velocity.rotated(rotation)
	get_parent().add_child(projectile)
	
	rotate_to_player_tween()
	
func rotate_to_player_tween():
	if is_instance_valid(player):
		tween = get_tree().create_tween()
		var dest_rotation = player.position.angle_to_point(position)
		
		# TODO BUG: not using fastest rotation
		if dest_rotation - dest_rotation >= PI/2:
			dest_rotation -= PI/2
		tween.tween_property($".", "rotation", dest_rotation, 2)
	else:
		print("Could not find player")
	
	
func kill():
	emit_signal("enemy_killed")
	queue_free()
	
	if randf() <= powerup_chance:
		var powerup: Node2D = powerup_template.instance()
		powerup.position = position
		get_parent().add_child(powerup)

func _on_Enemy_projectile_hit():
	kill()

func set_player(player_obj):
	player = player_obj


func _on_Enemy_lance_triggered():
	shoot()
