extends Node

signal score_updated (new_score)
signal misses_updated (new_misses)
signal time_updated(time_left)
signal game_over (won) 
signal change_dog_size (scale_modifier)

#/////////////////////////////////////////////////////	

var score :int = 0
var misses :int = 0


var game_time_left : float = 80 # 1m & 20s
var is_game_active : bool = false

var current_ball_air_time : float = 3.0
var min_ball_air_time : float = 0.6

#/////////////////////////////////////////////////////	

func _ready() -> void:
	start_game() #new

#/////////////////////////////////////////////////////	

func _process(delta: float) -> void:
	if !is_game_active:
		return
		
	game_time_left -= delta
	time_updated.emit(game_time_left)	
	
	var progress = game_time_left / 80.0
	current_ball_air_time = lerp(min_ball_air_time,3.0,progress)
	# المتغير اللي كنا عاملينه فوق لزمن الكره ف الهواء بيتغير من تلات ثواني ل0.6 ثانيه ..بيتغير بالراحه بناء علي مستوي التقدم 
	# lerp  تخلي الحركه بالراحه بناء علي مستوي التقدم...ومستوي التقدم بيتغير بناء علي الوقت المتبقي والتايمر يخلص
	
	if game_time_left <= 0:
		end_game()

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
	misses = 0
	game_time_left = 80
	is_game_active = true
	get_tree().call_group("Balls", "queue_free")# بيبمسح اي كوره قديمه كانت طايره ف الهواء لما نبدا من جديد 
		
#/////////////////////////////////////////////////////	
		
func end_game():
	is_game_active = false
	if score > misses:
		game_over.emit(true)
	else:
		game_over.emit(false)	
		
#/////////////////////////////////////////////////////					
