extends Area2D

var is_collected = false

func _ready() -> void:
	await get_tree().create_timer(6.0).timeout
	queue_free()



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	if body.has_method("player_boost"):
		$speed_sound.play()
		body.player_boost()
		$CollisionShape2D.set_deferred("disabled",true)
		$Sprite2D.visible = false
		$speed_particles.emitting = true
		await get_tree().create_timer($speed_particles.lifetime).timeout
		await $speed_sound.finished
		queue_free()
		
