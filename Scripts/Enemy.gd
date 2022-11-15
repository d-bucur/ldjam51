extends RigidBody2D

export(PackedScene) var projectile_template
export(PackedScene) var powerup_template
export var projectile_speed = 15000
export var projectile_offset = 100
export var powerup_chance = 1.0
export var reload_time = 1

signal enemy_killed(pos)
signal projectile_hit  # TODO should be damaged, as diffrent types of dmg can trigger it
signal lance_triggered
signal guide_show   # could be extracted into separate node like Highlight
signal guide_hide

var player: PhysicsBody2D
var ready_to_shoot = false
var dest_rotation

func _ready():
	$AimGuide.hide()
	yield(get_tree().create_timer(reload_time), "timeout")
	ready_to_shoot = true

func shoot():
	if !ready_to_shoot:
		return
		
	$Sprite.play("shooting")
		
#	print("Shooting")
	var projectile: Node2D = projectile_template.instance()
	projectile.rotation = rotation
	projectile.position = position + Vector2(projectile_offset, 0).rotated(rotation)
	var velocity = Vector2(projectile_speed, 0)
	projectile.linear_velocity = velocity.rotated(rotation)
	get_parent().call_deferred("add_child", projectile)
	
	rotate_to_player_tween()
	
	ready_to_shoot = false
	yield(get_tree().create_timer(reload_time), "timeout")
	ready_to_shoot = true
	
func rotate_to_player_tween():
	if is_instance_valid(player):
		dest_rotation = player.position.angle_to_point(position)
		var diff_wrapped = wrapf(dest_rotation - rotation, -PI, PI)
		dest_rotation = rotation + diff_wrapped
		var tween = get_tree().create_tween()
		tween.tween_property($".", "rotation", dest_rotation, 1)
	else:
		print_debug("Could not find player")
		
func _integrate_forces(state):
	if dest_rotation:
		# always override the internal physics engine rotation
		state.transform = Transform2D(dest_rotation, position)
	
	
func kill():
	emit_signal("enemy_killed", global_position)
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
	
func _on_Sprite_animation_finished():
	$Sprite.animation = "default"


func _on_Enemy_guide_show():
	$AimGuide.show()


func _on_Enemy_guide_hide():
	$AimGuide.hide()
