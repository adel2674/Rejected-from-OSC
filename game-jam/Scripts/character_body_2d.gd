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

# Live list of balls currently inside the hitboxes
var catchable_balls: Array[Node2D] = []

func _ready() -> void:
	hitbox_idle.body_entered.connect(_on_hitbox_body_entered)
	hitbox_idle.body_exited.connect(_on_hitbox_body_exited)
	hitbox_move.body_entered.connect(_on_hitbox_body_entered)
	hitbox_move.body_exited.connect(_on_hitbox_body_exited)

# Moved catch input completely out of physics_process for instant response
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("catch") and can_catch:
		if not catch_sfx.playing:
			catch_sfx.play() 
		can_catch = false
		catch_cooldown.start(0.55) 
		
		# Clean up any destroyed or freed balls from the array first
		for i in range(catchable_balls.size() - 1, -1, -1):
			if not is_instance_valid(catchable_balls[i]):
				catchable_balls.remove_at(i)
		
		if catchable_balls.size() > 0:
			GameManger.add_score()
			print("Score collected! Ball continues on its path.")
		else:
			GameManger.add_misses() 

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		jump_sfx.play()

	var direction := Input.get_axis("mleft", "mright")
	
	if direction < 0:
		animated_sprite_2d.flip_h = false
	elif direction > 0:
		animated_sprite_2d.flip_h = true
		
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

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
				
	var was_falling: bool = not is_on_floor() and velocity.y > 0.0
	
	move_and_slide()
	
	if was_falling and is_on_floor():
		landing_sfx.play()

func _on_catch_cooldown_timeout() -> void:
	can_catch = true

func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("ball") and body not in catchable_balls:
		catchable_balls.append(body)

func _on_hitbox_body_exited(body: Node2D) -> void:
	if body in catchable_balls:
		catchable_balls.erase(body)
