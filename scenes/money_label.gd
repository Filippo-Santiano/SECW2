extends Label

func _ready() -> void:
	update_money_label()

func update_money_label() -> void:
	self.text = str("Money: ", Global.Money)

#extends Label
#
##var pollutionLabel = 0
#@export var YearsTimer : Timer
#@export var MoneyLabel : Label
#
## Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#update_money_label()
#
#func update_money_label() -> void:
	#self.text = str("Money: ", Global.Money)
#
#func _on_years_timer_timeout() -> void:
	#Global.Money += Global.Income
	#update_money_label()


func _on_years_timer_timeout() -> void:
	Global.Money += Global.Income
	update_money_label()
	
