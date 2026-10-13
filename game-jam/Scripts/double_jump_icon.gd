extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().create_timer(6.0).timeout
	queue_free()



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	if body.name == "Dog":
		body.make_double_jump()
		$double_jump_sound.play()
		$CollisionShape2D.set_deferred("disabled",true)
		$Sprite2D.visible = false
		$double_jump_effect.emitting = true
		await get_tree().create_timer($double_jump_effect.lifetime).timeout
		await $double_jump_sound.finished
		queue_free()
