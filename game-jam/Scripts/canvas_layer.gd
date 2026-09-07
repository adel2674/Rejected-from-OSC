extends CanvasLayer


@onready var dog_label: Label = $dog_control/dog_label

@onready var main_munu: Control = $Main_Munu
@onready var start_button: Button = $Main_Munu/VBoxContainer/Start_Button


@onready var menu_buttons: VBoxContainer = $Main_Munu/VBoxContainer # العلبه اللي فيها زراير البدايه
@onready var how_to_play_panel: Panel = $Main_Munu/Panel

@onready var button_sound: AudioStreamPlayer2D = $button_sound


func _ready() -> void:
	get_tree().paused = true
	GameManger.score_updated.connect(_on_score_updated)
	GameManger.misses_updated.connect(_on_misses_updated)
	GameManger.lives_updated.connect(_on_lives_updated)#new
	GameManger.game_over.connect(_on_game_over)
	
func _process(delta: float) -> void:
	if GameManger.is_game_active:
		$fast_timer_label.text = GameManger.get_formatted_time()
		$fast_timer_label.show()
	else:
		$fast_timer_label.hide()
	
func _on_score_updated(new_score:int):
	$catch_sound.play()
	dog_label.text = str(new_score)
	
func _on_misses_updated(new_misses:int):
	$miss_sound.play()
	GameManger.lose_life()

func _on_game_over():
	$"../beach_sound".stop()
	var time_played = GameManger.get_formatted_time()
	$final_score_label.text = "Game Over!\nYour Score: " + str(GameManger.score) + "\nTime: "+time_played
	$final_score_label.show()
	$game_finish_sound.play()
	await $game_finish_sound.finished
	$final_score_label.hide()
	
	main_munu.show()
	start_button.text = "Play Again"	
	get_tree().paused = true

func _on_start_button_pressed() -> void:
	button_sound.play()
	main_munu.hide()
	$dog_control/dog_icon.show()
	$Hearts_container.show()
	$dog_control/dog_label.show()
	GameManger.start_game()
	$"../beach_sound".play()
	get_parent().get_node("ice_timer").start()
	get_parent().get_node("speed_timer").start()
	#timer_animation.play("timer")
	get_tree().paused = false
	
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
	
	
	#new
func _on_lives_updated(current_lives):
	var hearts = $Hearts_container.get_children()
	for i in range(hearts.size()):
		if i < current_lives:
			hearts[i].show()
		else:
			hearts[i].hide()
