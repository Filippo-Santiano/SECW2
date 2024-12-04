extends Control

var current_score = Global.calculate_final_score() # This gets the current score
@onready var score_label: Label = $scoreLabel
@onready var back_to_extras = preload("res://menus/pause_menu/extras_menu.tscn")
@onready var back_button: Button = $backButton

# Store current data
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
		var norm_happiness = (happiness_data[i] - min_happiness) / (max_happiness - min_happiness)		
		normalised_happiness.append(norm_happiness)				
		var norm_electricity = (electricity_data[i] - min_electricity) / (max_electricity - min_electricity)		
		normalised_electricity.append(norm_electricity)				
		var norm_pollution = (pollution_data[i] - min_pollution) / (max_pollution - min_pollution)		
		normalised_pollution.append(norm_pollution)				
		var norm_money = (money_data[i] - min_money) / (max_money - min_money)		
		normalised_money.append(norm_money)
		
	# Called when the node enters the scene tree for the first time.
func _ready() -> void:	
			
	# Print the final score	
	score_label.text = str("Your current score is: ", round(current_score))
			
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
		pass
		
func _draw():	
	
	# Set size of chart	
	var graph_width = 1300	
	var graph_height = 700	
	var start_x = 300	
	var start_y =950	
	var step_x = graph_width / max(1, happiness_data.size() - 1) # X-axis spacing between years		
	
	# Store data points in these lists	
	var points_happiness = []	
	var points_electricity = []	
	var points_pollution = []	
	var points_money = []
	
	# Calculate graph points for the length of one of the data arrays (all arrays will be same length	
	for i in range(happiness_data.size()):
		
		var x = start_x + i * step_x		
		# Maybe a condition here, if max_happiness - min_happiness == 0, we need the line to be horizontal
		var y = start_y - (happiness_data[i]-min_happiness)/(max_happiness-min_happiness+0.00001)*700	# Had to put +0.00001 to avoid division by 0
		points_happiness.append(Vector2(x, y))	
					
		var x_electricity = start_x + i * step_x		
		var y_electricity = start_y - (electricity_data[i]-min_electricity)/(max_electricity-min_electricity+0.00001)*700		
		points_electricity.append(Vector2(x_electricity, y_electricity))				
		
		var x_pollution = start_x + i * step_x		
		var y_pollution = start_y - (pollution_data[i]-min_pollution)/(max_pollution-min_pollution+0.00001)*700		
		points_pollution.append(Vector2(x_pollution, y_pollution))				
		
		var x_money = start_x + i * step_x		
		var y_money = start_y - (money_data[i]-min_money)/(max_money-min_money+0.00001)*700		
		points_money.append(Vector2(x_money, y_money))
		
	# Draw the line	
	for j in range(points_happiness.size() - 1):		
		draw_line(points_happiness[j], points_happiness[j + 1], Color(1, 1, 0), 6) #yellow		
		draw_line(points_electricity[j], points_electricity[j + 1], Color(0, 0, 1), 6) #blue		
		draw_line(points_pollution[j], points_pollution[j + 1], Color(1, 0, 0), 6) # red		
		draw_line(points_money[j], points_money[j + 1], Color(0, 1, 0), 6) #green
			
	# Draw the X and Y axes	
	draw_line(Vector2(start_x, start_y), Vector2(start_x + graph_width, start_y), Color(1, 1, 1), 6)  # X 	
	draw_line(Vector2(start_x, start_y), Vector2(start_x, start_y - graph_height), Color(1, 1, 1), 6)  # Y 
	
	# Draw chart legend with corresponding colours	
	draw_line(Vector2(start_x+1360, start_y - graph_height+160), Vector2(start_x+1410, start_y - graph_height+160), Color(1, 1, 0), 6)	
	draw_line(Vector2(start_x+1360, start_y - graph_height+225), Vector2(start_x+1410, start_y - graph_height+225), Color(0, 0, 1), 6)	
	draw_line(Vector2(start_x+1360, start_y - graph_height+290), Vector2(start_x+1410, start_y - graph_height+290), Color(1, 0, 0), 6)	
	draw_line(Vector2(start_x+1360, start_y - graph_height+355), Vector2(start_x+1410, start_y - graph_height+355), Color(0, 1, 0), 6)

# Return to extras when 'Back' button pressed
func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_packed(back_to_extras)
