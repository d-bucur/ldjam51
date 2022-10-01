extends KinematicBody2D

export var speed = 15000

signal player_killed
signal projectile_hit

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
		
func kill():
	print("Player killed")
	emit_signal("player_killed")
		
func on_lance_triggered():
	pass


func _on_Player_projectile_hit():
	kill()
