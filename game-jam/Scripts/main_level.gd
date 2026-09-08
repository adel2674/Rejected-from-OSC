extends Node2D

var ice_scene = preload("res://Scenes/ice.tscn")
var speed_icon_scene = preload("res://Scenes/speed_icon.tscn")

func _ready() -> void:
	pass 



func _process(delta: float) -> void:
	pass


func _on_ice_timer_timeout() -> void:
	var ice_instance = ice_scene.instantiate()
	var rondom_x = randf_range(-529,520)
	var fixed_y = randf_range(52,60)
	ice_instance.global_position = Vector2(rondom_x,fixed_y)
	add_child(ice_instance)


func _on_speed_timer_timeout() -> void:
	var speed_icon_instance = speed_icon_scene.instantiate()
	var rondom_x = randf_range(-529,520)
	var fixed_y = randf_range(52,60)
	speed_icon_instance.global_position = Vector2(rondom_x,fixed_y)
	add_child(speed_icon_instance )
