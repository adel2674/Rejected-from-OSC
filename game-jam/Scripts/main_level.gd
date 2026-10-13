extends Node2D

var ice_scene = preload("res://Scenes/ice.tscn")
var speed_icon_scene = preload("res://Scenes/speed_icon.tscn")
var new_heart_scene = preload("res://Scenes/heart_pickup.tscn")
var double_jump_scene = preload("res://Scenes/double_jump_icon.tscn")

func _ready() -> void:
	GameManger.rondom_heart.connect(_on_rondom_heart)
	$double_jump_timer.start()


func _process(delta: float) -> void:
	pass

func _on_rondom_heart():
	var heart = new_heart_scene.instantiate()
	var rondom_x = randf_range(-525,505)
	var rondom_y = randf_range(52,60)
	
	heart.global_position = Vector2(rondom_x,rondom_y)
	add_child(heart)
	
	
	
func _on_ice_timer_timeout() -> void:
	var ice_instance = ice_scene.instantiate()
	var rondom_x = randf_range(-525,505)
	var rondom_y = randf_range(52,60)
	ice_instance.global_position = Vector2(rondom_x,rondom_y)
	add_child(ice_instance)


func _on_speed_timer_timeout() -> void:
	var speed_icon_instance = speed_icon_scene.instantiate()
	var rondom_x = randf_range(-525,505)
	var rondom_y = randf_range(52,60)
	speed_icon_instance.global_position = Vector2(rondom_x,rondom_y)
	add_child(speed_icon_instance )


func _on_double_jump_timer_timeout() -> void:
	var double_jump_instance = double_jump_scene.instantiate()
	var rondom_x = randf_range(-525,505)
	var rondom_y = randf_range(52,60)
	double_jump_instance.global_position = Vector2(rondom_x,rondom_y)
	add_child(double_jump_instance )
