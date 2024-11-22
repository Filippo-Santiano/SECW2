extends Control
#
#var prev_environment = 0
#var prev_happiness = 0
#var prev_economy = 0
#var prev_coins = 0
#
#func _ready() -> void:
	## Connect to GameManager's stats_updated signal
	#var gm = get_node("/root/Main/GameManager")
	#gm.connect("stats_updated", Callable(self, "_on_stats_updated"))
	#_update_ui()  # Initial update
#
#func _update_ui():
	#var gm = get_node("/root/Main/GameManager")
	#$VBoxContainer/ColorRect/Environment/EnvBar.value = gm.environment
	#$VBoxContainer/ColorRect2/Happiness/ProgressBar.value = gm.happiness
	#$VBoxContainer/ColorRect3/Economy/ProgressBar.value = gm.economy
	#$VBoxContainer/ColorRect4/Coins/ProgressBar.value = gm.coins
#
#func _on_stats_updated():
	#_update_ui()

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
