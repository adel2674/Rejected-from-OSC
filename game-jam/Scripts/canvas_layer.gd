extends CanvasLayer


@onready var dog_label: Label = $dog_control/dog_label
@onready var loser_label: Label = $loser_control/loser_label



@onready var timer: Timer = $Timer
@onready var timer_label: Label = $timer_box/timer_label

@onready var timer_sound: AudioStreamPlayer2D = $timer_sound

@onready var main_munu: Control = $Main_Munu
@onready var start_button: Button = $Main_Munu/VBoxContainer/Start_Button
@onready var timer_animation: AnimatedSprite2D = $timer_box/timer_animation

@onready var menu_buttons: VBoxContainer = $Main_Munu/VBoxContainer # العلبه اللي فيها زراير البدايه
@onready var how_to_play_panel: Panel = $Main_Munu/Panel

@onready var button_sound: AudioStreamPlayer2D = $button_sound


func _ready() -> void:
	GameManger.score_updated.connect(_on_score_updated)
	GameManger.misses_updated.connect(_on_misses_updated)
	GameManger.time_updated.connect (_on_time_updated)
	GameManger.game_over.connect(_on_game_over)
	
func _process(delta: float) -> void:
	pass
	
	
	
func _on_score_updated(new_score:int):
	$catch_sound.play()
	dog_label.text = str(new_score)
	
func _on_misses_updated(new_misses:int):
	loser_label.text = str(new_misses)
	$miss_sound.play()
	
func _on_time_updated(time_left:float):
	var minutes = int (time_left)/60
	var seconds = int (time_left) % 60
	timer_label.text = "%02d:%02d" % [minutes,seconds]
	
func _on_game_over(won:bool):
	timer_sound.stop()	
	$"../beach_sound".stop()
	timer_animation.stop()
	main_munu.show()
	start_button.text = "Play Again"

# ابقي امسح الداله اللي تحت دي	
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		# اضغط Z لتجربة زيادة سكور الكلب وحركة الشريط + الصوت
		if event.keycode == KEY_Z:
			GameManger.add_score()
			
		# اضغط X لتجربة الخسارة وحركة شريط الخسارة + الصوت
		elif event.keycode == KEY_X:
			GameManger.add_misses()	


func _on_start_button_pressed() -> void:
	button_sound.play()
	main_munu.hide()
	GameManger.start_game()
	$"../beach_sound".play()
	$timer_sound.play()
	timer_animation.play("timer")
	
func _on_exit_button_pressed() -> void:
	button_sound.play()
	await button_sound.finished
	get_tree().quit()


func _on_how_to_button_pressed() -> void:
	button_sound.play()
	menu_buttons.hide() #احنا بنخفي علبه الازرار بتاع المنيو مش المنيو لان المنيو تشمل الازرار دي و هاو تو بلاي
	how_to_play_panel.show()


func _on_back_button_pressed() -> void:
	button_sound.play()
	how_to_play_panel.hide()
	menu_buttons.show() 
