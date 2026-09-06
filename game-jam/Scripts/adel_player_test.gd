extends CharacterBody2D

var is_frozen = false
var speed = 300




func _physics_process(delta: float) -> void:
	if is_frozen:
		return
	
	var direction := Input.get_axis("ui_left", "ui_right")
	velocity.x = direction * speed
	
	var dir_y = Input.get_axis("ui_up","ui_down")
	velocity.y = dir_y *speed
	
	move_and_slide()
	
func freeze_player():
	is_frozen = true
	await get_tree().create_timer(2.0).timeout
	is_frozen = false
	
