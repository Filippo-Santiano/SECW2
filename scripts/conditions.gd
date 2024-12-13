class_name Conditions
extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


### Functions for Pollution ###
func poll_pos_to_neg() -> bool:
	return Global.Pollution < 0
	
func poll_half_thresh() -> bool:
	return Global.Pollution * 2 > Global.PollutionThreshold

func poll_greater_thresh() -> bool:
	return Global.Pollution > Global.PollutionThreshold


### Functions for Happiness ###
func happ_low() -> bool:
	return Global.Happiness < 0.3

func happ_high() -> bool:
	return Global.Happiness > 0.99


### Functions for Income ###
func income_30() -> bool:
	return Global.IncomeChange < 0.70 and Global.IncomeChange > 0.5
	
func income_50() -> bool:
	return Global.IncomeChange < 0.50

func inc_growth_above_150() -> bool:
	return Global.IncomeChange > 1.5
	
func inc_below_200_after_50() -> bool:
	return Global.Income < 200 and Global.currentYear == 50

func inc_above_200_after_50() -> bool:
	return Global.Income > 200 and Global.currentYear == 50


### Functions for Electricity ###
func elec_over_160() -> bool:
	return Global.Electricity >1.6
	
func elec_over_100() -> bool:
	return Global.Electricity>1.0
	
func elec_adequate() -> bool:
	return Global.Electricity >0.5
	
func elec_under_20() -> bool:
	return Global.Electricity<0.2


### Functions for Yearly Pollution
func yp_strong_negative() -> bool:
	return Global.YearlyPollution>= 200.0
	
func yp_negative() -> bool:
	return Global.YearlyPollution >50
	
func yp_strong_postive() -> bool:
	return Global.YearlyPollution <-200
	
func yp_positive() -> bool:
	return Global.YearlyPollution <-50
