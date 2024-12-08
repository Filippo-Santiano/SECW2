extends Control

var final_score = Global.calculate_final_score() # This gets the final score
@onready var score_label: Label = $scoreLabel # To print score

# Store every year's data in relevant variables
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
	
	# Loop through data and append to list (all lists are same length so append norm data in one for loop)
	for i in range(happiness_data):
		# Use normalisation formula
		var norm_happiness = (happiness_data[i] - min_happiness) / (max_happiness - min_happiness+0.0001)
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

func _ready():
	# Print the final score
	score_label.text = str("Your final score is: ", round(final_score))
	
		#function to calculate Y values - if the values are equal, it returns the original value to stop zerodivisionerror
func calculate_y(data_value, min_value, max_value, graph_height, start_y):
	if max_value == min_value:
		return start_y  # Default to `start_y` if range is zero
	return start_y - ((data_value - min_value) / (max_value - min_value)) * graph_height

func _draw():
	# Set size of chart
	var graph_width = 1300
	var graph_height = 700
	var start_x = 300
	var start_y = 950
	var step_x = graph_width / max(1, happiness_data.size() - 1)  

	# Store data points in these lists
	var points_happiness = []
	var points_electricity = []
	var points_pollution = []
	var points_money = []

	# Calculate graph points for the length of one of the data arrays all arrays will be same length
	for i in range(happiness_data.size()):
		var x = start_x + i * step_x

		# Append calculated points for each dataset
		points_happiness.append(Vector2(x, calculate_y(happiness_data[i], min_happiness, max_happiness, graph_height, start_y)))
		points_electricity.append(Vector2(x, calculate_y(electricity_data[i], min_electricity, max_electricity, graph_height, start_y)))
		points_pollution.append(Vector2(x, calculate_y(pollution_data[i], min_pollution, max_pollution, graph_height, start_y)))
		points_money.append(Vector2(x, calculate_y(money_data[i], min_money, max_money, graph_height, start_y)))

	# Draw the line
	for j in range(points_happiness.size() - 1):
		draw_line(points_happiness[j], points_happiness[j + 1], Color(1, 1, 0), 6)  # Yellow
		draw_line(points_electricity[j], points_electricity[j + 1], Color(0, 0, 1), 6)  # Blue
		draw_line(points_pollution[j], points_pollution[j + 1], Color(1, 0, 0), 6)  # Red
		draw_line(points_money[j], points_money[j + 1], Color(0, 1, 0), 6)  # Green

		# Draw the X and Y axes
		draw_line(Vector2(start_x, start_y), Vector2(start_x + graph_width, start_y), Color(1, 1, 1), 6)  # X-axis
		draw_line(Vector2(start_x, start_y), Vector2(start_x, start_y - graph_height), Color(1, 1, 1), 6)  # Y-axis

		# Draw chart legend with corresponding colors
		var legend_x_start = start_x + graph_width + 60
		var legend_y_start = start_y - graph_height + 160
		var legend_spacing = 65
		draw_line(Vector2(legend_x_start, legend_y_start), Vector2(legend_x_start + 50, legend_y_start), Color(1, 1, 0), 6)  # Happiness - Yellow
		draw_line(Vector2(legend_x_start, legend_y_start + legend_spacing), Vector2(legend_x_start + 50, legend_y_start + legend_spacing), Color(0, 0, 1), 6)  # Electricity - Blue
		draw_line(Vector2(legend_x_start, legend_y_start + 2 * legend_spacing), Vector2(legend_x_start + 50, legend_y_start + 2 * legend_spacing), Color(1, 0, 0), 6)  # Pollution - Red
		draw_line(Vector2(legend_x_start, legend_y_start + 3 * legend_spacing), Vector2(legend_x_start + 50, legend_y_start + 3 * legend_spacing), Color(0, 1, 0), 6)  # Money - Green
