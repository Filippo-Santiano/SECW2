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
@export var electricity_bar_negative: ProgressBar
@export var electricity_bar_positive: ProgressBar


func _ready() -> void:
	# Connect to GameManager's stats_updated signal
	var yt = get_node("/root/Main/YearsTimer")
	yt.connect("YearPassed", Callable(self, "_update_ui"))
	_update_ui()  # Initial update
	
func change_bar_colour(progress_bar, value: float):
	if value <= 25:
		progress_bar.add_theme_stylebox_override("fill", NEGATIVE_PROGRESS_BAR)
	elif value > 25 and value <= 50:
		progress_bar.add_theme_stylebox_override("fill", NEUTRAL_PROGRESS_BAR)
	else:
		progress_bar.add_theme_stylebox_override("fill", POSITIVE_PROGRESS_BAR)
		
	
func _update_ui():
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
	
	
	
	
	
	#$VBoxContainer/ColorRect3/BarPercentage3.text = str(round(gm.economy)) + '%'
	#$VBoxContainer/ColorRect4/BarPercentage4.text = str(round(gm.coins)) + '%'
	
	#if gm.economy < 0:
		#$VBoxContainer/ColorRect3/Economy/EnvBar7.value = abs(gm.economy)
		#$VBoxContainer/ColorRect3/Economy/EnvBar8.value = 0
	#elif gm.economy > 0:
		#$VBoxContainer/ColorRect3/Economy/EnvBar8.value = gm.economy
		#$VBoxContainer/ColorRect3/Economy/EnvBar7.value = 0
	#if gm.coins < 0:
		#$VBoxContainer/ColorRect4/Coins/EnvBar9.value = abs(gm.coins)
		#$VBoxContainer/ColorRect4/Coins/EnvBar10.value = 0
	#elif gm.coins > 0:
		#$VBoxContainer/ColorRect4/Coins/EnvBar10.value = gm.coins
		#$VBoxContainer/ColorRect4/Coins/EnvBar9.value = 0


#extends Control
#
## Variables to store previous stat values
#var prev_environment = 0
#var prev_happiness = 0
#var prev_economy = 0
#var prev_coins = 0
#
## Called when the node is added to the scene
#func _ready():
	## Connect to GameManager's stats_updated signal
	#var game_manager = get_node("/root/Main/GameManager")
	#game_manager.connect("stats_updated", Callable(self, "_on_stats_updated"))
	#_update_ui()  # Initial update
#
## Updates the UI with the current values from GameManager
#func _update_ui():
	#var gm = get_node("/root/Main/GameManager")
	#$VBoxContainer/ColorRect/Environment/EnvBar.value = gm.environment
	#$VBoxContainer/ColorRect2/Happiness/ProgressBar.value = gm.happiness
	#$VBoxContainer/ColorRect3/Economy/ProgressBar.value = gm.economy
	#$VBoxContainer/ColorRect4/Coins/ProgressBar.value = gm.coins
#
## Signal handler for when stats are updated
#func _on_stats_updated():
	#var gm = get_node("/root/Main/GameManager")
	#
	## Flash only containers with changed stats
	#if gm.environment != prev_environment:
		#_flash_env($VBoxContainer/ColorRect/Environment)
	#if gm.happiness != prev_happiness:
		#_flash_happiness($VBoxContainer/ColorRect2/Happiness)
	#if gm.economy != prev_economy:
		#_flash_economy($VBoxContainer/ColorRect3/Economy)
	#if gm.coins != prev_coins:
		#_flash_coins($VBoxContainer/ColorRect4/Coins)
	#
	## Update previous values
	#prev_environment = gm.environment
	#prev_happiness = gm.happiness
	#prev_economy = gm.economy
	#prev_coins = gm.coins
	#
	#_update_ui()  # Ensure the UI reflects the latest stats
#
## Flash the environment stat container
#func _flash_env(_container):
	#var original_color = _container.modulate
	#_container.modulate = Color(1, 1, 0)  # Flash yellow
	#await get_tree().create_timer(0.2).timeout  # Flash duration
	#_container.modulate = original_color
#
## Flash the happiness stat container
#func _flash_happiness(_container):
	#var original_color = _container.modulate
	#_container.modulate = Color(0, 1, 0)  # Flash green
	#await get_tree().create_timer(0.2).timeout  # Flash duration
	#_container.modulate = original_color
#
## Flash the economy stat container
#func _flash_economy(_container):
	#var original_color = _container.modulate
	#_container.modulate = Color(1, 0, 0)  # Flash red
	#await get_tree().create_timer(0.2).timeout  # Flash duration
	#_container.modulate = original_color
#
## Flash the coins stat container
#func _flash_coins(_container):
	#var original_color = _container.modulate
	#_container.modulate = Color(0, 0, 1)  # Flash blue
	#await get_tree().create_timer(0.2).timeout  # Flash duration
	#_container.modulate = original_color
