extends Label

#var pollutionLabel = 0
@export var YearsTimer : Timer
@export var PollutionLabel : Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_pollution_label()

func update_pollution_label() -> void:
	self.text = str("Pollution: ", Global.Pollution)

func _on_years_timer_timeout() -> void:
	Global.Pollution += Global.YearlyPollution
	update_pollution_label()
