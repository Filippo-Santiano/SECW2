extends Timer
@export var YearsLabel : Label
@export var PollutionLabel : Label
@export var IncomeLabel : Label
@export var MoneyLabel : Label

@export var ElectricityLabel: Label
@export var HappinessLabel: Label
@export var YearlyPollution: Label
@export var ExternalPollution: Label

@export var ProgressBars : Control

@export var yearsPerMinute : float = 1.0
var Years = 0.0

signal YearPassed

# Connection to lose screen
@onready var you_lose = preload("res://scenes/you_lose.tscn")

# Updates the labels each year
func updateLabels():
	YearsLabel.text = str("Year: ", int(Global.currentYear))
	PollutionLabel.text = str("Pollution: ", round(Global.Pollution), " / ", round(Global.PollutionThreshold))
	IncomeLabel.text = str("Income: ", round(Global.Income))
	MoneyLabel.text = str("Money: ", round(Global.Money))



func _ready() -> void:
	#connect("YearPassed", Callable(self, "_on_year_passed"))
	updateLabels()
	
func _on_timeout() -> void:
	Years += yearsPerMinute / 60 #Timer runs every second meaning we can get reasonably granular with different
	#..construction times etc. As such mins per year can be set in this script/in the inspector and we divide by 60 to get how
	#much time to add per second.
	yearPassed() #Checks if one year has passed. If so, emits the YearPassed signal for use with adding pollution, income etc.
	Global.currentYear = Years
	
	#print("Year:", Years, " | Pollution:", Global.Pollution, " | Income:", Global.Income, " | Electricity:", Global.Electricity, " | Happiness:", Global.Happiness)
	
	updateLabels() #update labels every second
	ProgressBars.update_ui()
	
	# Updates the stats evry year
func update_stats_every_year():
	
	# Calls the function to update each tile in the game
	Global.update_tile_attributes()
	
	# Temporary variables so that the labels don't go to zero at the beginning of each year
	var tempYearlyPollution = 0
	var tempIncome = 0
	var electricityRequired = 1
	var electricityGenerated = 2
	var tempHappinessPos = 30
	var tempHappinessNeg = 0
	
	# Iterate through each tile's attributes and sums them to temp values
	for pos in Global.tile_data.keys():
		var tile = Global.tile_data[pos]
		tempYearlyPollution += tile["attributes"]["yearly_pollution"]
		tempIncome += tile["attributes"]["income"]
		print("Temporary income 1: ", tempIncome)
		electricityRequired += tile["attributes"]["electricityRequired"]
		electricityGenerated += tile["attributes"]["electricityGenerated"]
		tempHappinessPos += tile["attributes"]["positiveHappiness"]
		tempHappinessNeg += tile["attributes"]["negativeHappiness"]
		
	# If generated is < required, income is decreased by a factor of generated / required
	if (electricityGenerated < electricityRequired):
		# # Avoids division by 0
		if electricityRequired != 0:
			tempIncome *= (electricityGenerated/ electricityRequired)
	
	print("Temporary income 2: ", tempIncome)	
	# Updating the global values
	Global.YearlyPollution = tempYearlyPollution
	Global.Income = tempIncome
	Global.ElectricityGenerated = electricityGenerated
	Global.ElectricityRequired = electricityRequired
	Global.Electricity = electricityGenerated - electricityRequired
	Global.Money += Global.Income
	Global.Pollution += Global.YearlyPollution
	Global.Pollution += Global.ExternalPollution
	
	# Calculates the happiness percentage 
	if (tempHappinessPos > tempHappinessNeg):
		Global.Happiness = 1 #This is 100%
	else:
		if tempHappinessNeg != 0:
			Global.Happiness = (tempHappinessPos/tempHappinessNeg)
			
	# Sets pollution threshold and then calculates pollution threshold based on happiness
	Global.PollutionThreshold = 1000 * Global.Happiness
	Global.updateExternalPollution()
	
	# Calculate change in income
	if Global.PreviousIncome > 0:
		Global.IncomeChange = Global.Income / Global.PreviousIncome
	else:
		Global.IncomeChange = 1.0
	
	# Update Previous Income
	Global.PreviousIncome = Global.Income

	
var prevYear = 0
var exceed_threshold_count = 0

func yearPassed():
	if int(Years) > prevYear:
		emit_signal("YearPassed")
		print("YEAR PASSED")
		prevYear = Years
		update_stats_every_year()
		# Add the yearly stats to list
		Global.collect_yearly_data()
		print("Pollution Threshold: ", Global.PollutionThreshold)
		# Variable to store current score, used for final score
		var current_score = Global.calculate_final_score()
		print("Current Score", current_score)
		if (Global.Money == 0 and Global.Income < 25):
			# prints Bye Bye, not enough mulah
			print("Bye Bye, not enough mulah")
			# Change to lose screen
			get_tree().change_scene_to_packed(you_lose)
		# If above the threshold, add one to the count, if th count gets above 3, you lose, count resets if you go below
		elif (Global.Pollution > Global.PollutionThreshold):
			Global.Years_Over +=1
			if (Global.Years_Over > 2):
				# Change to lose screen
				get_tree().change_scene_to_packed(you_lose)
				
		else:
			Global.Years_Over = 0
			



func _on_year_passed() -> void:
	print("Yearly income: ", Global.Income)
	
	#print(Global.tile_data)
	#Global.updateMaximumIncome()
	
	updateLabels()
	#print("Year:", Global.currentYear, "| Pollution:", Global.Pollution, "| Income:", Global.Income)
	#Global.Electricity = Global.Electricity # May not be necessary
	#Global.Happiness = Global.Happiness
