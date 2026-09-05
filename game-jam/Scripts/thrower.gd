extends CharacterBody2D
@onready var ani: AnimatedSprite2D = $AnimatedSprite2D
@onready var ball: RigidBody2D = $"../ball"
const SPEED = 300.0
const JUMP_VELOCITY = -400.0
@export var target_character: CharacterBody2D

func throw():
		ball.throw(target_character.global_position)
		ani.play("throw")
		await ani.animation_finished
		ani.play("default")
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("ball"):
		throw()
