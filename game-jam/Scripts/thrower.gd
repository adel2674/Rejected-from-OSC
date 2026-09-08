extends CharacterBody2D

@onready var ani: AnimatedSprite2D = $AnimatedSprite2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@export var target_character: CharacterBody2D

# --- NEW: Movement limits for the thrower ---
@export var min_x: float = 0.0
@export var max_x: float = 100.0

func throw(ball: RigidBody2D):
	ball.throw(target_character.global_position)
	ani.play("throw")
	$pop_sound.play()
	
	# --- NEW: Move to a random X position immediately after throwing ---
	var random_x = randf_range(min_x, max_x)
	var tween = get_tree().create_tween()
	# Slide smoothly to the new X position over 0.4 seconds
	tween.tween_property(self, "global_position:x", random_x, 0.4).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	# ------------------------------------------------------------------
	
	await ani.animation_finished
	ani.play("default")
		
		
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("ball"):
		throw(body)
