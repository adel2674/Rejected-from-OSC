extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().create_timer(7.0).timeout
	queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	if body.name == "Dog":
		if GameManger.lives<5:
			GameManger.add_life()
			$health_pickup.play()
			$CollisionShape2D.set_deferred("disabled",true)
			$Sprite2D.visible = false
			await $health_pickup.finished
			queue_free()
