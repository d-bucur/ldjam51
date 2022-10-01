extends Node2D

export var time_to_full_rotation = 10

var rotation_speed

func _ready():
	rotation_speed = 2 * PI / time_to_full_rotation


func _process(delta):
	$Lance.rotate(rotation_speed * delta)


func _on_Area2D_body_entered(body):
	body.on_lance_triggered()
