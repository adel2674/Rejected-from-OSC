extends CharacterBody2D

var SPEED = 450.0


const JUMP_VELOCITY = -600.0
var can_catch := true

var is_frozen = false
var is_collected = false

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var idle_coll: CollisionShape2D = $idle_coll
@onready var move_coll: CollisionShape2D = $move_coll
@onready var jump_sfx: AudioStreamPlayer2D = $jump_sfx
@onready var landing_sfx: AudioStreamPlayer2D = $landing_sfx
@onready var catch_sfx: AudioStreamPlayer2D = $catch_sfx
@onready var catch_cooldown: Timer = $catch_cooldown


@onready var camera: Camera2D = $Camera2D

@onready var hitbox_move: Area2D = $hitbox_move
@onready var hitbox_idle: Area2D = $hitbox_idle
var was_in_air = false
@onready var fx: CPUParticles2D = $"../effect/CPUParticles2D"
@onready var effect: Node2D = $"../effect"

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
			
			effect.global_position = catchable_balls[0].global_position
			fx.restart() 
			
			# Trigger the shake AND the freeze at the exact same time!
			apply_screen_shake(15.0, 0.15)
			apply_hit_stop(0.2)
			
		
			
		else:
			apply_screen_shake(5.0, 0.2)
			GameManger.add_misses() 


func _physics_process(delta: float) -> void:
	
	if is_frozen:
		return
		
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
func apply_hit_stop(duration: float = 0.08) -> void:
	# Freeze the game completely
	Engine.time_scale = 0.0
	
	# Create a timer that waits for 'duration' seconds. 
	# The 'true' at the very end tells this timer to IGNORE the frozen time_scale!
	await get_tree().create_timer(duration, true, false, true).timeout
	
	# Unfreeze the game
	Engine.time_scale = 1.0
func apply_screen_shake(intensity: float = 8.0, duration: float = 0.15) -> void:
	if not camera: return
	
	# Create a tween that explicitly IGNORES the frozen time_scale
	var tween = get_tree().create_tween().set_ignore_time_scale(true)
	
	# Create 5 rapid, random jagged movements
	var step_time = duration / 5.0
	for i in range(5):
		var random_offset = Vector2(randf_range(-intensity, intensity), randf_range(-intensity, intensity))
		tween.tween_property(camera, "offset", random_offset, step_time)
		
	# Snap the camera perfectly back to the center at the end
	tween.tween_property(camera, "offset", Vector2.ZERO, 0.05)

	
func freeze_player():
	is_frozen = true
	await get_tree().create_timer(2.0).timeout
	is_frozen = false
	
func player_boost():
	is_collected = true
	SPEED = SPEED * 1.5
	await get_tree().create_timer(6.0).timeout	
	is_collected = false
	SPEED = SPEED / 1.5
