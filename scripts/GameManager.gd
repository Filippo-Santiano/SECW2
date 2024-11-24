extends Node

var environment: float = 100
var happiness: float = 0
var economy: float = 0
var coins: float = 0

#signal that other parts of the game can connect to. 
#It gets emitted whenever any of the stats are updated, enabling real-time updates in the game.
signal stats_updated

func update_stat(stat_name: String, value: float):
	match stat_name:
		"environment":
			environment = clamp(environment + value, -100, 100) #clamp ensures the updated value remains within the valid range of 0 to 100.
		"happiness":
			happiness = clamp(happiness + value, -100, 100)
		"economy":
			economy = clamp(economy + value, -100, 100)
		"coins":
			coins = clamp(coins + value, -100, 100)
	emit_signal("stats_updated")

#extends Node
#
## Stats : These variables represent the game's core stats initial values are assigned to each sta
#var environment: float = 0
#var happiness: float = 10
#var economy: float = 50
#var coins: float = 50
##
## Signal for notifying UI-Whenever a stat changes, this signal will notify other parts of the game (like the UI) to update.
#signal stats_updated
#
## Update a stat and emit the signal
#func update_stat(stat_name: String, value: float):
	#match stat_name:
		#"environment":
			#environment = clamp(environment + value, 0, 100)
		#"happiness":
			#happiness = clamp(happiness + value, 0, 100)
		#"economy":
			#economy = clamp(economy + value, 0, 100)
		#"coins":
			#coins = clamp(coins + value, 0, 100)
	#emit_signal("stats_updated") #After updating the stat, the signal stats_updated is emitted This tells any connected nodes  to update their displays to reflect the new values.
