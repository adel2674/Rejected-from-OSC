extends CanvasLayer

@onready var dog_bar: HSlider = $dog_bar
@onready var loser_bar: HSlider = $loser_bar



func _ready() -> void:
	GameManger.score_updated.connect(_on_score_updated)
	GameManger.misses_updated.connect(_on_misses_updated)

func _process(delta: float) -> void:
	pass
	
func _on_score_updated(new_score:int):
	dog_bar.value = new_score
	
func _on_misses_updated(new_misses:int):
	loser_bar.value = new_misses
