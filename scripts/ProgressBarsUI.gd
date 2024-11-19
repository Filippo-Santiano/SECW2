#extends the Node class, which means it can be added to a scene and can be used as a general-purpose node for logic and management.
extends Control

# Called when the node is added to the scene
func _ready():
	# Connect to GameManager's stats_updated signal
	var game_manager = get_node("/root/Main/GameManager")
	game_manager.connect("stats_updated", Callable(self, "_on_stats_updated"))#Connects the stats_updated signal from GameManager to the _on_stats_updated() function in this script.
	_update_ui()  # Initial update

# Updates the UI with the current values from GameManager
func _update_ui():

	var gm = get_node("/root/Main/GameManager")
	$VBoxContainer/ColorRect/Environment/EnvBar.value = gm.environment
	$VBoxContainer/ColorRect2/Happiness/ProgressBar.value = gm.happiness
	$VBoxContainer/ColorRect3/Economy/ProgressBar.value = gm.economy
	$VBoxContainer/ColorRect4/Coins/ProgressBar.value = gm.coins

# Signal handler for when stats are updated
func _on_stats_updated():
	_update_ui()
	_flash_containers()

# Flash containers when their stats change
func _flash_containers():
	_flashEnv($VBoxContainer/ColorRect/Environment)
	_flashHappiness($VBoxContainer/ColorRect2/Happiness)
	_flashEconomy($VBoxContainer/ColorRect3/Economy)
	_flashCoins($VBoxContainer/ColorRect4/Coins)

# Handle the flashing effect
func _flashEnv(_container):
	var Env_color = $VBoxContainer/ColorRect/Environment.modulate
	$VBoxContainer/ColorRect/Environment.modulate = Color(1, 1, 0)  # Flash yellow
	await get_tree().create_timer(0.2).timeout  # Flash duration
	$VBoxContainer/ColorRect/Environment.modulate = Env_color
	
func _flashHappiness(container):	
	var Happiness_color = $VBoxContainer/ColorRect2/Happiness.modulate
	$VBoxContainer/ColorRect2/Happiness.modulate = Color(0, 1, 0)  # Flash yellow
	await get_tree().create_timer(0.2).timeout  # Flash duration
	$VBoxContainer/ColorRect2/Happiness.modulate = Happiness_color
	
func _flashEconomy(container):	
	var economy_color = $VBoxContainer/ColorRect3/Economy.modulate
	$VBoxContainer/ColorRect3/Economy.modulate = Color(1, 0, 0)  # Flash yellow
	await get_tree().create_timer(0.2).timeout  # Flash duration
	$VBoxContainer/ColorRect3/Economy.modulate = economy_color
	
func _flashCoins(container):	
	var coins_color = $VBoxContainer/ColorRect4/Coins.modulate
	$VBoxContainer/ColorRect4/Coins.modulate = Color(0, 0,1)  # Flash yellow
	await get_tree().create_timer(0.2).timeout  # Flash duration
	$VBoxContainer/ColorRect4/Coins.modulate = coins_color
