extends KinematicBody2D

export var speed = 15000

signal player_killed
signal projectile_hit
signal lance_triggered

var enemies_in_movement_area = {}

func _ready():
	get_tree().call_group("enemies", "set_player", self)

func _process(delta):
	var velocity = Vector2.ZERO
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
		
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		move_and_slide(velocity * delta)
		
	if Input.is_action_pressed("drag"):
		for enemy in enemies_in_movement_area.values():
			enemy.move_and_slide(velocity * delta)
		
func kill():
	print("Player killed")
	emit_signal("player_killed")


func _on_Player_projectile_hit():
	kill()


func _on_MovementArea_body_entered(body):
	enemies_in_movement_area[body.get_instance_id()] = body


func _on_MovementArea_body_exited(body):
	enemies_in_movement_area.erase(body.get_instance_id())
