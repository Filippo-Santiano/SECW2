extends Timer
var Years = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_timeout() -> void:
	start()
	#Years += 0.25
	#For testing
	Years += 1
	Global.currentYear = Years
	Global.Pollution += Global.YearlyPollution
	var pollution_label = get_node("PollutionLabel")
	pollution_label.update_pollution_label()
	print("Pollution:", Global.Pollution)
	print(Global.YearlyPollution)
