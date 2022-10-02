extends Control

func show_game_over():
	var animation_time = 0.2
	var tween = create_tween()
	tween.tween_interval(1)
	tween.tween_callback($DeathScreen, "show")
	tween.parallel().tween_property($DeathScreen, "rect_position:y", 350.0, animation_time).from(500.0)
	tween.parallel().tween_property($DeathScreen, "modulate:a", 1.0, animation_time).from(0.0)
