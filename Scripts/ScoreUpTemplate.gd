extends Control

export var move_dir = Vector2(0, -25)
export var animation_time = 0.25

func _ready():
	var tween = get_tree().create_tween()
	tween.tween_property($".", "rect_position", rect_position + move_dir, animation_time)
	tween.tween_callback(self, "queue_free")
