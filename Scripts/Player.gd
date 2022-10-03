extends RigidBody2D

export var speed = 25000

signal player_killed(obj)
signal projectile_hit
signal lance_triggered

var enemies_in_movement_area = {}  # not just enemies but draggable objects
var dragging_objects = {}
var speed_actual

func _ready():
	get_tree().call_group("enemies", "set_player", self)
	speed_actual = speed

func _physics_process(delta):
	var velocity = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	if velocity.length() > 1:
		velocity = velocity.normalized()
	velocity *= speed_actual * delta
	
	if velocity.length() > 0:
		apply_central_impulse(velocity)
		$Sprite.animation = "walk"
	else:
		$Sprite.animation = "idle"
	
	if Input.is_action_just_pressed("drag"):
		for enemy in enemies_in_movement_area.keys():
			dragging_objects[enemy] = enemies_in_movement_area[enemy]
			
	if Input.is_action_just_released("drag"):
		dragging_objects.clear()
		
	if Input.is_action_pressed("drag"):
		for enemy in dragging_objects.values():
			if is_instance_valid(enemy):
				enemy.apply_central_impulse(velocity)
		
func kill():
	print("Player killed")
	emit_signal("player_killed", self)
#	queue_free()


func _on_Player_projectile_hit():
	kill()


func _on_MovementArea_body_entered(body):
	enemies_in_movement_area[body.get_instance_id()] = body
	body.emit_signal("drag_start")


func _on_MovementArea_body_exited(body):
	enemies_in_movement_area.erase(body.get_instance_id())
	body.emit_signal("drag_end")


func _on_SlowmoArea_activate_slowmo(slowmo_scale):
	print("Slowing down %f" % slowmo_scale)
	print("Speed: %f" % speed_actual)
	speed_actual *= 5
	print("Speed: %f" % speed_actual)


func _on_SlowmoArea_deactivate_slowmo():
	speed_actual = speed
