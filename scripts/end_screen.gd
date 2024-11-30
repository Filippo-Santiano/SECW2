extends Control

var pollution_end_target  #to check how many years exceed the criteria
var money_end_target # to check money is under criteria
var unhappiness_target # to  check happiness rate is under criteria
@export var end_screen = "res://scenes/end_screen_pollution.tscn"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if pollution_end_target >= 3:
		get_tree().change_to_next_scene()
	
	
	
	# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
