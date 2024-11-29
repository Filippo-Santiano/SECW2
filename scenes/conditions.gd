class_name Conditions
extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func poll_pos_to_neg() -> bool:
	return Global.Pollution < 0
	

func poll_half_thresh() -> bool:
	return Global.Pollution * 2 > Global.PollutionThreshold

func poll_greater_thresh() -> bool:
	return Global.Pollution > Global.PollutionThreshold
func happ_low() -> bool:
	return Global.Happiness < 0.3

func happ_high() -> bool:
	return Global.Happiness > 0.99
	
func income_30() -> bool:
	return Global.Income < 0.30
	
func income_50() -> bool:
	return Global.Income <0.50
func growth_above_150() -> bool:
	return Global.Income > 1.5
	
func below_70_after_50() -> bool:
	return Global.Income <0.7
	
func over_160() -> bool:
	return Global.Electricity >1.6
	
func over_100() -> bool:
	return Global.Electricity>1.0
	
func adequate() -> bool:
	return Global.Electricity >0.5
	
func under_20() -> bool:
	return Global.Electricity<0.2
	
func strong_negative() -> bool:
	return Global.YearlyPollution>= 200.0
func negative() -> bool:
	return Global.YearlyPollution >50
func strong_postive() -> bool:
	return Global.YearlyPollution <-200
func positive() -> bool:
	return Global.YearlyPollution <-50
