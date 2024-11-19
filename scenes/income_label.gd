extends Label

#var pollutionLabel = 0
@export var YearsTimer : Timer
@export var IncomeLabel : Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_income_label()

func update_income_label() -> void:
	self.text = str("Income: ", Global.Income)

#func _on_years_timer_timeout() -> void:
	#Global.Money += Global.Income
	#update_income_label()
