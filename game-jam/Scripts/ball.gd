extends RigidBody2D

@export var ball_scene: PackedScene
# Allows drives (20°) to steep lobs (70°)
var min_angle_deg: float = 15.0
var max_angle_deg: float = 75.0

@onready var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
var stick_to_player=false
var current_thrower:CharacterBody2D
func _physics_process(delta: float) -> void:
	if stick_to_player:
		position=current_thrower.position
func throw(target_pos: Vector2) -> void:
	# FIX: Consistently use global_position for both axes
	var delta_x: float = target_pos.x - global_position.x
	var dist_x: float = abs(delta_x)
	var delta_y: float = global_position.y - target_pos.y 
	
	var denominator: float = 0.0
	var rad: float = 0.0
	var cos_a: float = 0.0
	
	
	# FIX: Prevent silent failures if the random angle is too shallow to reach a high target
	while denominator <= 0.0:
		var angle_deg: float = randf_range(min_angle_deg, max_angle_deg)
		rad = deg_to_rad(angle_deg)
		cos_a = cos(rad)
		denominator = 2.0 * cos_a * cos_a * (dist_x * tan(rad) - delta_y)

	# Safety check in case even the fallback fails (target is directly above)
	if denominator <= 0.0:
		return
		
	var speed: float = sqrt((gravity * dist_x * dist_x) / denominator)
	var new_velocity := Vector2(sign(delta_x) * speed * cos_a, -speed * sin(rad))
	var spin_speed: float = 15.0
	set_deferred("angular_velocity", sign(delta_x) * spin_speed)
	# FIX: set_deferred ensures the physics engine accepts the velocity change 
	# even if throw() is called directly from a collision signal
	set_deferred("linear_velocity", new_velocity)
