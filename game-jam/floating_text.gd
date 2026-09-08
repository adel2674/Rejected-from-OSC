extends Node2D

func start_floating(spawn_position: Vector2) -> void:
	global_position = spawn_position
	
	# Create a tween that ignores your hit-stop time scale
	var tween = get_tree().create_tween().set_ignore_time_scale(true)
	
	# Move upward 60 pixels over 0.5 seconds
	tween.tween_property(self, "global_position:y", global_position.y - 60, 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	
	# Fade out opacity to 0 at the same time
	tween.parallel().tween_property(self, "modulate:a", 0.0, 0.5).set_ease(Tween.EASE_IN)
	
	# Safely delete the node when the animation finishes
	tween.tween_callback(queue_free)
