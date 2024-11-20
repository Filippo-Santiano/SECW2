extends Timer

var Years = 0.0

func _ready() -> void:
	# Correct connection: Use "self" as the target and specify the callback function correctly.
	connect("timeout", Callable(self, "_on_timeout"))

func _on_timeout() -> void:
	#Years += 1  # Increment the year
	#Global.Pollution += Global.YearlyPollution  # Update pollution
	#Global.Money += Global.Income  # Update money
	#start()
	#Years += 0.25
	#For testing
	Years += 1
	Global.currentYear = Years
	Global.Pollution += Global.YearlyPollution
	var pollution_label = get_node("PollutionLabel")
	pollution_label.update_pollution_label()
	print("Pollution:", Global.Pollution)
	print(Global.YearlyPollution)

	# Update stats in GameManager
	var gm = get_node("/root/Main/GameManager")
	gm.update_stat("environment", -Global.YearlyPollution)  #  Decrease environment health
	gm.update_stat("economy", Global.Income)  # Increase economy
	gm.update_stat("happiness", 2)  # Arbitrary increase in happiness as no label present 
	gm.update_stat("coins", Global.Money)

	print("Year:", Years, " | Pollution:", Global.Pollution, " | Income:", Global.Income)

#extends Timer
#var Years = 0.0
#
## Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#pass # Replace with function body.
#
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass
#
#
#func _on_timeout() -> void:
	#start()
	##Years += 0.25
	##For testing
	#Years += 1
	#Global.Pollution += Global.YearlyPollution
	#var pollution_label = get_node("PollutionLabel")
	#pollution_label.update_pollution_label()
	#print("Pollution:", Global.Pollution)
	#print(Global.YearlyPollution)
