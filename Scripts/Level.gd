extends Node2D

export(PackedScene) var enemy_template
export(PackedScene) var city_template
export var time_to_full_rotation = 10

var rotation_speed
var score = 0

func _ready():
	rotation_speed = 2 * PI / time_to_full_rotation
	randomize()
	$UI/DeathScreen.hide()


func _process(delta):
	$Level/Lance.rotate(rotation_speed * delta)
	
	
func spawn_enemy():
#	print_debug("Spawning new enemy")
	var enemy = enemy_template.instance()
	var spawn_location = $Level/Lance/EnemySpawnPath/PathFollow2D
	spawn_location.offset = randi()
	enemy.position = spawn_location.global_position
	$Enemies.add_child(enemy)
	
	enemy.connect("enemy_killed", $".", "_on_Enemy_enemy_killed")
	
	if ($Player):
		enemy.look_at($Player.position)
		enemy.set_player($Player)
	
func spawn_city():
	var city = city_template.instance()
	var spawn_location = $Level/CitySpawnPath/PathFollow2D
	spawn_location.offset = randi()
	city.position = spawn_location.global_position
	city.connect("player_killed", self, "_on_Player_player_killed")
	$Enemies.add_child(city)


func _on_SpawnTimer_timeout():
	spawn_enemy()


func _on_Player_lance_triggered():
	spawn_enemy()
	

func _on_Lance_body_entered(body):
	body.emit_signal("lance_triggered")


func _on_Player_player_killed():
	get_tree().paused = true
	$UI/DeathScreen.show()
	$UI/DeathScreen/ScoreLabel.text = str(score)


func _on_Restart_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()


func _on_Enemy_enemy_killed():
	score += 1
	$UI/Score.text = str(score)


func _on_CitySpawnTimer_timeout():
	spawn_city()
