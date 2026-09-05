extends CanvasLayer

@onready var dog_bar: HSlider = $dog_bar
@onready var loser_bar: HSlider = $loser_bar


@onready var timer: Timer = $Timer
@onready var timer_label: Label = $timer_box/timer_label

@onready var timer_sound: AudioStreamPlayer2D = $timer_sound



func _ready() -> void:
	GameManger.score_updated.connect(_on_score_updated)
	GameManger.misses_updated.connect(_on_misses_updated)
	GameManger.time_updated.connect (_on_time_updated)
	GameManger.game_over.connect(_on_game_over)
	
func _process(delta: float) -> void:
	pass
	#var time_left = timer.time_left
	#var minutes = int (time_left)/60
	#var seconds = int (time_left) % 60
	#timer_label.text = "%02d:%02d" % [minutes,seconds]
	
	
func _on_score_updated(new_score:int):
	$catch_sound.play()
	dog_bar.value = new_score
	
func _on_misses_updated(new_misses:int):
	loser_bar.value = new_misses
	$miss_sound.play()
	
func _on_time_updated(time_left:float):
	var minutes = int (time_left)/60
	var seconds = int (time_left) % 60
	timer_label.text = "%02d:%02d" % [minutes,seconds]
	
func _on_game_over(won:bool):
	timer_sound.stop()	
	$"../beach_sound".stop()
	
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		# اضغط Z لتجربة زيادة سكور الكلب وحركة الشريط + الصوت
		if event.keycode == KEY_Z:
			GameManger.add_score()
			
		# اضغط X لتجربة الخسارة وحركة شريط الخسارة + الصوت
		elif event.keycode == KEY_X:
			GameManger.add_misses()	
