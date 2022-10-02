extends Node2D

export var time_to_full_rotation = 10

var rotation_speed = 2 * PI / time_to_full_rotation

func _process(delta):
	rotation += rotation_speed * delta
