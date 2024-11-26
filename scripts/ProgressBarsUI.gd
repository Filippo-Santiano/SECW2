extends Control

var prev_environment = 0
var prev_happiness = 0
var prev_economy = 0
var prev_coins = 0

const NEGATIVE_PROGRESS_BAR = preload("res://scenes/negative_progress_bar.tres")
const NEUTRAL_PROGRESS_BAR = preload("res://scenes/neutral_progress_bar.tres")
const POSITIVE_PROGRESS_BAR = preload("res://scenes/positive_progress_bar.tres")

@export var environment_bar: ProgressBar
@export var env_bar_percentage: Label

@export var happiness_bar: ProgressBar
@export var happy_bar_percentage: Label

@export var economy_bar: ProgressBar
@export var econ_bar_percentage: Label

@export var electricity_bar: ProgressBar
@export var elec_bar_percentage: Label

func _ready() -> void:
	update_ui()  # Initial update

func change_bar_colour(progress_bar, value: float):
	if value <= 25:
		progress_bar.add_theme_stylebox_override("fill", NEGATIVE_PROGRESS_BAR)
	elif value > 25 and value <= 50:
		progress_bar.add_theme_stylebox_override("fill", NEUTRAL_PROGRESS_BAR)
	else:
		progress_bar.add_theme_stylebox_override("fill", POSITIVE_PROGRESS_BAR)
		
	
func update_ui():
	#Acces pollution values
	var current_pollution = Global.Pollution
	var pollution_threshold = Global.PollutionThreshold
	# For environment, need to get current pollution / max threshold as a percentage.
	# Then subtract it from 100 because environment goes down when pollution goes up.
	var environment_percentage = 0
	if pollution_threshold != 0:
		var pollution_percentage = (current_pollution/pollution_threshold) * 100
		environment_percentage = round(100 - pollution_percentage)
		change_bar_colour(environment_bar, environment_percentage)
		
	env_bar_percentage.text = str(environment_percentage) + '%'
	environment_bar.value = environment_percentage
		
	# Access global happiness to display it
	var happiness_percentage = round(Global.Happiness * 100)
	change_bar_colour(happiness_bar, happiness_percentage)
	# Assign values to bars
	happy_bar_percentage.text = str(happiness_percentage) + '%'
	happiness_bar.value = happiness_percentage
	
	var economy_percentage = 0
	if Global.MaximumIncome != 0:
		economy_percentage = round(100 * Global.Income / Global.MaximumIncome)
	change_bar_colour(economy_bar, economy_percentage)
	
	econ_bar_percentage.text = str(economy_percentage) + '%'
	economy_bar.value = economy_percentage
	
	# Calculate generated over required
	var electricityPercentage = 0

	if Global.ElectricityGenerated != 0:
		electricityPercentage = round(100 * Global.ElectricityGenerated / Global.ElectricityRequired)
	
	# Display text
	elec_bar_percentage.text = str(electricityPercentage) + '%'
	
	# the electricity bar shows 50% full when electricityPercentage is 100%
	electricity_bar.value = clamp(electricityPercentage / 2, 0, 100)
	
	# Update electricity bar colours
	if electricityPercentage <= 40 or electricityPercentage >= 160:
		electricity_bar.add_theme_stylebox_override("fill", NEGATIVE_PROGRESS_BAR)
	elif (electricityPercentage > 40 and electricityPercentage <= 80) or (electricityPercentage >= 120 and electricityPercentage < 160):
		electricity_bar.add_theme_stylebox_override("fill", NEUTRAL_PROGRESS_BAR)
	else:
		electricity_bar.add_theme_stylebox_override("fill", POSITIVE_PROGRESS_BAR)
