extends Sprite

export var rotation_speed = PI/2

func _ready():
	hide()
	get_parent().add_user_signal("drag_start")
	get_parent().connect("drag_start", self, "show")
	get_parent().add_user_signal("drag_end")
	get_parent().connect("drag_end", self, "hide")
	
func _process(delta):
	rotation += rotation_speed * delta
