extends CharacterBody2D

const SPEED = 450.0
const JUMP_VELOCITY = -600.0
var can_catch := true

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var idle_coll: CollisionShape2D = $idle_coll
@onready var move_coll: CollisionShape2D = $move_coll
@onready var jump_sfx: AudioStreamPlayer2D = $jump_sfx
@onready var landing_sfx: AudioStreamPlayer2D = $landing_sfx
@onready var catch_sfx: AudioStreamPlayer2D = $catch_sfx
@onready var catch_cooldown: Timer = $catch_cooldown

@onready var hitbox_move: Area2D = $hitbox_move
@onready var hitbox_idle: Area2D = $hitbox_idle

var was_in_air = false

func _physics_process(delta: float) -> void:
	# 1. Gravity and Jump Input
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		jump_sfx.play()

	# 2. Movement Logic
	var direction := Input.get_axis("mleft", "mright")
	
	if direction < 0:
		animated_sprite_2d.flip_h = true
	elif direction > 0:
		animated_sprite_2d.flip_h = false
		
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	# 3. Animation and Collision State Machine
	if not is_on_floor():
		animated_sprite_2d.play("jump")
	else:
		if direction == 0: 
			animated_sprite_2d.play("idle")
			if idle_coll.disabled:
				idle_coll.set_deferred("disabled", false)
				move_coll.set_deferred("disabled", true)
		else:
			animated_sprite_2d.play("move")
			if move_coll.disabled:
				idle_coll.set_deferred("disabled", true)
				move_coll.set_deferred("disabled", false)
				
	# -------------------------------------------------------------
	# 4. Catch Logic 
	# -------------------------------------------------------------؟
	if Input.is_action_just_pressed("catch") and can_catch == true:
		
		can_catch = false
		catch_cooldown.start(0.55) 
		var caught_the_ball = false
		
		var overlapping_bodies = hitbox_idle.get_overlapping_bodies() + hitbox_move.get_overlapping_bodies()
		for body in overlapping_bodies:
			if body.is_in_group("ball"):
				caught_the_ball = true
				break 
		if caught_the_ball:
			GameManger.add_score()
			if not catch_sfx.playing:
				catch_sfx.play()
		else:
			GameManger.add_misses() 

	# -------------------------------------------------------------
	
	var was_falling: bool = not is_on_floor() and velocity.y > 0.0
	
	move_and_slide()
	
	if was_falling and is_on_floor():
		landing_sfx.play()

func _on_catch_cooldown_timeout() -> void:
	can_catch = true
