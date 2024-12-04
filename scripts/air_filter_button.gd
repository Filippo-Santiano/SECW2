extends Button

@export var RedCost : Label
@export var GreenCost : Label

var cost : int = 1000

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if cost != Global.AIR_FILTER_REPAIR_COST:
		cost = Global.AIR_FILTER_REPAIR_COST
	set_cost_text(str("Cost: £", cost))

func set_cost_text(text):
	RedCost.text = text
	GreenCost.text = text

func _on_years_timer_timeout() -> void:
	#Check to update colour every second
	if Global.Money < cost:
		GreenCost.hide()
		RedCost.show()
	else:
		RedCost.hide()
		GreenCost.show()


func _on_pressed() -> void:
	if Global.chargeMoney(cost):
		Global.repairAirFilter()
