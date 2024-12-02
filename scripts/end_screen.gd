extends Control

var pollution_end_target  #to check how many years exceed the criteria
var money_end_target # to check money is under criteria
var unhappiness_target # to  check happiness rate is under criteria
var whole_game_data = Global.get_yearly_data() # This returns a list of each year's data
var final_score = Global.calculate_final_score() # This gets the final score
@onready var score_label: Label = $scoreLabel # 

# Store every year's data in relevant variable
#var happiness_data = [] 
#happiness_data = whole_game_data[0].get("Happiness") 
#var electricity_data = whole_game_data["Electricity"]
#var pollution_data = whole_game_data["Pollution"]
#var money_data = whole_game_data["Money"]
#var yearly_data
var happiness_data = Global.happiness_data
var electricity_data = Global.electricity_data
var pollution_data = Global.pollution_data
var money_data = Global.money_data

# Find minimum/maximum of each data list
var max_happiness = happiness_data.max()
var min_happiness = happiness_data.min()
var max_electricity = electricity_data.max()
var min_electricity = electricity_data.min()
var max_pollution = pollution_data.max()
var min_pollution = pollution_data.min()
var max_money = money_data.max()
var min_money = money_data.min()

# Lists for normalised data
var normalised_happiness = []
var normalised_electricity = []
var normalised_pollution = []
var normalised_money = []

# Function calculates normalised data and stores in above lists
func store_normalised_data() -> void:
	
	# Loop through data and append to list (all lists are same length so append norm data in one for loop
	for i in range(happiness_data):
		# Use normalisation formula
		var norm_happiness = (happiness_data[i] - min_happiness) / (max_happiness - min_happiness)
		normalised_happiness.append(norm_happiness)
		
		var norm_electricity = (electricity_data[i] - min_electricity) / (max_electricity - min_electricity)
		normalised_electricity.append(norm_electricity)
		
		var norm_pollution = (pollution_data[i] - min_pollution) / (max_pollution - min_pollution)
		normalised_pollution.append(norm_pollution)
		
		var norm_money = (money_data[i] - min_money) / (max_money - min_money)
		normalised_money.append(norm_money)


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
	
	
func _draw():
	var graph_width = 1300
	var graph_height = 700
	var start_x = 300
	var start_y = 1000
	var step_x = graph_width / max(1, happiness_data.size() - 1) # X-axis spacing between years
	
	

	  #  each category to plot its line graph
	
	var points_happiness = []
	var points_electricity = []
	var pollution = []
	var points_money = []
		# Calculate graph points for the length of one of the data arrays (all arrays will be same length
	for i in range(happiness_data.size()):
		
		var x = start_x + i * step_x
		var y = start_y - (happiness_data[i]-min_happiness)/(max_happiness-min_happiness)
		points_happiness.append(Vector2(x, y))

	# Draw the line
	for j in range(points_happiness.size() - 1):
		draw_line(points_happiness[j], points_happiness[j + 1], Color(1, 1, 0), 2)

	# Draw the X and Y axes
	draw_line(Vector2(start_x, start_y), Vector2(start_x + graph_width, start_y), Color(1, 1, 1), 2)  # X 
	draw_line(Vector2(start_x, start_y), Vector2(start_x, start_y - graph_height), Color(1, 1, 1), 2)  # Y 
	
