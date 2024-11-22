extends Timer
@export var YearsLabel : Label
@export var PollutionLabel : Label
@export var IncomeLabel : Label
@export var MoneyLabel : Label
@export var gm : Node
@export var ElectricityLabel: Label
@export var HappinessLabel: Label

@export var yearsPerMinute : float = 1.0
var Years = 0.0

signal YearPassed

func updateLabels():
	YearsLabel.text = str("Year: ", int(Global.currentYear))
	PollutionLabel.text = str("Pollution: ", Global.Pollution)
	IncomeLabel.text = str("Income: ", Global.Income)
	MoneyLabel.text = str("Money: ", Global.Money)
	ElectricityLabel.text = str("Electricity: ", Global.Electricity)
	HappinessLabel.text = str("Happiness: ", Global.Happiness)

func _ready() -> void:
	updateLabels()
	
func _on_timeout() -> void:
	Years += yearsPerMinute / 60 #Timer runs every second meaning we can get reasonably granular with different
	#..construction times etc. As such mins per year can be set in this script/in the inspector and we divide by 60 to get how
	#much time to add per second.
	yearPassed() #Checks if one year has passed. If so, emits the YearPassed signal for use with adding pollution, income etc.
	Global.currentYear = Years

	print("Year:", Years, " | Pollution:", Global.Pollution, " | Income:", Global.Income, " | Electricity:", Global.Electricity, " | Happiness:", Global.Happiness)
	
	updateLabels() #update labels every second

var prevYear = 0
func yearPassed():
	if int(Years) > prevYear:
		emit_signal("YearPassed")
		print("YEAR PASSED")
		prevYear = Years

func _on_year_passed() -> void:
	
	Global.Money += Global.Income
	Global.Pollution += Global.YearlyPollution
	Global.Electricity = Global.Electricity # May not be necessary
	Global.Happiness = Global.Happiness

	# Update stats in GameManager
	gm.update_stat("environment", -Global.YearlyPollution)  #  Decrease environment health
	gm.update_stat("economy", Global.Income)  # Increase economy
	gm.update_stat("happiness", 2)  # Arbitrary increase in happiness as no label present 
	gm.update_stat("coins", Global.Money)
