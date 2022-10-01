extends Node2D

export(PackedScene) var enemy_template
export var time_to_full_rotation = 10

var rotation_speed

func _ready():
	rotation_speed = 2 * PI / time_to_full_rotation
	randomize()
	spawn_enemy()


func _process(delta):
	$Lance.rotate(rotation_speed * delta)
	
	
func spawn_enemy():
	print_debug("Spawning new enemy")
	var enemy = enemy_template.instance()
	var spawn_location = $Lance/SpawnPath/PathFollow2D
	
	spawn_location.offset = randi()
	enemy.position = spawn_location.global_position
	# TODO bug: don't shoot on first spawn
	enemy.set_player($"../Player")
	add_child(enemy)


func _on_Area2D_body_entered(body):
	# TODO move to lance script
	body.emit_signal("lance_triggered")


func _on_SpawnTimer_timeout():
	spawn_enemy()


func _on_Player_lance_triggered():
	spawn_enemy()
