extends CanvasLayer



func _ready() -> void:
	if ! DisplayServer.is_touchscreen_available():
		hide()# لو الجهاز لا يدعم اللمس اخفيه


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
