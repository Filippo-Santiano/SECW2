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
	
func happ_low() -> bool:
	return Global.Happiness < 0.85

func happ_high() -> bool:
	return Global.Happiness > 0.99
