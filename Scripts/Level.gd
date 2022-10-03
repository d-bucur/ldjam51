extends Node2D

export(PackedScene) var enemy_template
export(PackedScene) var city_template
export(PackedScene) var highlight_death_template
export(PackedScene) var score_up_template
export var time_to_full_rotation = 10
export var enemy_spawn_time_factor = 0.85  # the lower this is the harder the game will get

signal game_over
signal enemy_killed(pos)
signal add_score(pos)

var rotation_speed
var score = 0

func _ready():
	if !$"/root/Music".playing:
		$"/root/Music".play()
	rotation_speed = 2 * PI / time_to_full_rotation
	randomize()
	$UI/DeathScreen.hide()
	spawn_enemy()
	spawn_enemy()


func _process(delta):
	$Level/Lance.rotate(rotation_speed * delta)
	
	
func spawn_enemy():
#	print_debug("Spawning new enemy")
	var enemy = enemy_template.instance()
	var spawn_location = $Level/Lance/EnemySpawnPath/PathFollow2D
	spawn_location.offset = randi()
	enemy.position = spawn_location.global_position
	$Enemies.call_deferred("add_child", enemy)
	
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
	$Enemies.call_deferred("add_child", city)


func _on_SpawnTimer_timeout():
	spawn_enemy()


func _on_Player_lance_triggered():
	spawn_enemy()
	

func _on_Lance_body_entered(body):
	body.emit_signal("lance_triggered")


func _on_Player_player_killed(obj):
	get_tree().paused = true
	$UI/DeathScreen/ScoreLabel.text = str(score)

	var highlight = highlight_death_template.instance()
	highlight.position = obj.global_position
	$Enemies.add_child(highlight)
	
	$UI.show_game_over()
	emit_signal("game_over")


func _on_Restart_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()


func _add_score(pos):
	score += 1
	$UI/Score.text = str(score)
	# TODO should be inside UI
	var indicator = score_up_template.instance()
	indicator.rect_position = pos
	$UI.add_child(indicator)
	

func _on_Enemy_enemy_killed(pos):
	_add_score(pos)
	emit_signal("enemy_killed")


func _on_CitySpawnTimer_timeout():
	spawn_city()


func _on_EnemyTimerDifficulty_timeout():
	$Level/Lance/EnemySpawnPath/EnemySpawnTimer.wait_time *= enemy_spawn_time_factor


func _on_Main_add_score(pos):
	_add_score(pos)
