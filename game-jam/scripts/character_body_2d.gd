extends CharacterBody2D

const SPEED = 150.0
const JUMP_VELOCITY = -300.0


@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var idle_coll: CollisionShape2D = $idle_coll
@onready var move_coll: CollisionShape2D = $move_coll

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		animated_sprite_2d.play("jump")
		idle_coll.disabled = false
		move_coll.disabled = true
		print("move coll")
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("mleft", "mright")
	
	if direction < 0:
		animated_sprite_2d.flip_h = true
	elif direction > 0:
		animated_sprite_2d.flip_h = false
		
	# ربط الأنيميشن بأشكال التصادم
	if direction == 0: 
		animated_sprite_2d.play("idle")
		idle_coll.disabled = false
		move_coll.disabled = true
		print("idle coll")
	else:
		animated_sprite_2d.play("move")
		idle_coll.disabled = true
		move_coll.disabled = false
		print("move coll")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	move_and_slide()
