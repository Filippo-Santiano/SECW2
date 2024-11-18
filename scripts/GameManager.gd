extends Node

# Stats : These variables represent the game's core stats initial values are assigned to each sta
var environment: float = 100
var happiness: float = 90
var economy: float = 50
var coins: float = 50

# Signal for notifying UI-Whenever a stat changes, this signal will notify other parts of the game (like the UI) to update.
signal stats_updated

# Update a stat and emit the signal
func update_stat(stat_name: String, value: float):
	match stat_name:
		"environment":
			environment = clamp(environment + value, 0, 100)
		"happiness":
			happiness = clamp(happiness + value, 0, 100)
		"economy":
			economy = clamp(economy + value, 0, 100)
		"coins":
			coins = clamp(coins + value, 0, 100)
	emit_signal("stats_updated") #After updating the stat, the signal stats_updated is emitted This tells any connected nodes  to update their displays to reflect the new values.
