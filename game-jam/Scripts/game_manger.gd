extends Node

signal score_updated (new_score)
signal misses_updated (new_misses)
#signal time_updated(time_left)
signal game_over () #new
signal change_dog_size (scale_modifier)

#/////////////////////////////////////////////////////	

var time_elapsed : float = 0

var score :int = 0
var misses :int = 0


var lives = 5
signal lives_updated(current_lives)

var is_game_active : bool = false

var current_ball_air_time : float = 3.0
var min_ball_air_time : float = 0.6

#/////////////////////////////////////////////////////	

func _ready() -> void:
	pass # عشان اللعبه متبداش غير لو داس ستارت
	

#/////////////////////////////////////////////////////	
func _process(delta:float) -> void:
	if !is_game_active:
		return
	time_elapsed +=delta	
#/////////////////////////////////////////////////////	
		
func add_score():
	if !is_game_active:
		return
	score += 1	
	score_updated.emit(score)
	check_dog_size_change()
	
#/////////////////////////////////////////////////////	
	
func add_misses():
	if !is_game_active:
		return
	misses += 1
	misses_updated.emit(misses)	
	check_dog_size_change()	
#//////////////////////////////////
func lose_life():
	if !is_game_active:
		return
	lives-=1
	lives_updated.emit(lives)
	if lives <= 0:
		is_game_active = false
		emit_signal("game_over")#ابدا اجراءا نهايه اللعبه
		
	


	
#/////////////////////////////////////////////////////	
		
func check_dog_size_change():
	var total_plays = score + misses
	if  total_plays !=0 and total_plays%2 == 0:
		rondom_dog_size()
#/////////////////////////////////////////////////////	
			
func rondom_dog_size():
	var sizes = [0.5 , 1, 1.5]
	var rondom_size = sizes.pick_random()
	change_dog_size.emit(rondom_size)
	
#/////////////////////////////////////////////////////		
		
func start_game():
	score = 0
	lives = 5 #new
	time_elapsed = 0.0
	is_game_active = true
	# عشان يتصفر علي الui
	score_updated.emit(score)
	lives_updated.emit(lives)#new
	
	get_tree().call_group("Balls", "queue_free")# بيبمسح اي كوره قديمه كانت طايره ف الهواء لما نبدا من جديد 
		
#/////////////////////////////////////////////////////	
func get_formatted_time() -> String:
	var minutes = int(time_elapsed) / 60
	var seconds = int(time_elapsed) % 60
	# حساب الأجزاء من الثانية (رقمين بيجروا بسرعة جداً)
	var msec = int(fmod(time_elapsed, 1.0) * 100) 
	
	# الشكل النهائي هيكون مثلاً: 01:15:84
	return "%02d:%02d:%02d" % [minutes, seconds, msec]
#/////////////////////////////////////////////////////
