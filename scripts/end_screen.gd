extends Control

var pollution_end_target  #to check how many years exceed the criteria
var money_end_target # to check money is under criteria
var unhappiness_target # to  check happiness rate is under criteria
var whole_game_data = Global.get_yearly_data() # This returns a list of each year's data
var final_score = Global.calculate_final_score() # This gets the final score
@onready var score_label: Label = $scoreLabel # 
var yearly_data


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
# to set the result line chart's appearance
var categories = ["Money", "Pollution", "Electricity", "Happiness"]
var colors = {
	"Money": Color(0, 1, 0),       # green
	"Pollution": Color(1, 0, 0),   # red
	"Electricity": Color(0, 0, 1), # blue
	"Happiness": Color(1, 1, 0)    # yellow
}

func _ready():
	# Print the final score
	score_label.text = str("Your final score is: ", round(final_score))

	yearly_data = [
		{"Year": 2021, "Money": 100, "Pollution": 500, "Electricity": 500, "Happiness": 500},
		{"Year": 2022, "Money": 200, "Pollution": 500, "Electricity": 400, "Happiness": 300},
		{"Year": 2023, "Money": 300, "Pollution": 200, "Electricity": 300, "Happiness": 100},
		{"Year": 2024, "Money": 500, "Pollution": 100, "Electricity": 100, "Happiness": 100},
	]
 
	
func _draw():
	var max_value = 300  # Assumed maximum value for normalization
	var graph_width = 1300
	var graph_height = 700
	var start_x = 300
	var start_y = 1000
	var step_x = graph_width / max(1, yearly_data.size() - 1) # X-axis spacing between years

	  #  each category to plot its line graph
	for category in categories:
		var points = []
		# Calculate graph points for the current category
		for i in range(yearly_data.size()):
			var normalized_value = yearly_data[i][category] / max_value * graph_height  # Normalize data
			var x = start_x + i * step_x
			var y = start_y - normalized_value
			points.append(Vector2(x, y))

		# Draw the line
		for j in range(points.size() - 1):
			draw_line(points[j], points[j + 1], colors[category], 2)

	# Draw the X and Y axes
	draw_line(Vector2(start_x, start_y), Vector2(start_x + graph_width, start_y), Color(1, 1, 1), 2)  # X 
	draw_line(Vector2(start_x, start_y), Vector2(start_x, start_y - graph_height), Color(1, 1, 1), 2)  # Y 
	
