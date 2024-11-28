extends Control
 
# Eventually we will add functionality to remove the last message if the length of messages exceeds a number.
 
# Adjust the add function
# add new messages for different instances in game
# Create warning message when you are over the threshold



# Positive Sustainability Headlines
var good_messages = [
	"City Makes Significant Strides in Reducing Carbon Footprint",
	"New Initiatives Promote Clean Energy and Environmental Awareness",
	"Green Spaces Flourish as City Invests in Biodiversity",
	"Public Transit Improvements Support Sustainable City Goals",
	"Water Conservation Efforts Gain Strong Community Support",
	"City Takes Steps Towards Achieving Zero Waste",
	"Recycling Programs Show Encouraging Progress",
	"Air Quality Sees Positive Change with New Environmental Policies",
	"Community-Led Projects Boost Sustainability Efforts",
	"City Strengthens Partnership with Renewable Energy Providers"
]
 
# Negative Sustainability Headlines
var bad_messages = [
	"City Struggles to Meet Sustainability Targets",
	"Environmental Programs Face Setbacks Amid Funding Issues",
	"Green Spaces Decline as Urbanization Increases",
	"Challenges in Public Transit Affect City's Environmental Goals",
	"Water Conservation Efforts Hampered by Drought Conditions",
	"Recycling Programs See Decreased Participation",
	"Air Quality Concerns Rise Due to Increased Pollution",
	"Government Cuts Threaten Progress in Environmental Initiatives",
	"Waste Management Faces Overload as Demands Grow",
	"Renewable Energy Targets Delayed Due to Infrastructure Challenges"
]

# Queue of messages to be displayed in the feed
var message_queue = []
var rng = RandomNumberGenerator.new()
var prev_good_message_index = 0
var prev_bad_message_index = 0

var is_expanded = false # Track whether the feed is expanded to show all messages
@export var v_box_container: VBoxContainer
@export var show_all_button: Button
@onready var feed_item_scene = load("res://scenes/feed_item.tscn")
var prevPollution = Global.Pollution

# We thought that we could also add a button to hide this entire view

func _ready():
	pass
 
func _process(delta):
	add_messages()
	show_messages()
	pass

# Loop through: Pollution, Yearly_Pollution, Electricity, Happiness, Income

# Pollution
# When Pollution changes from positive to negative
# When Pollution is 50% of threshold value
# When Pollution is over the threshold and Years_Over

# Yearly_Pollution
# When its + 50 (negative message) 
# When its + 200 (Strong negative)
# When its - 50 (positive)
# When its - 200 (strong positive)

# Electricity
# When you are generating excess, over 160% (neon green)
# When you are generating more than you need, over 100% (green)
# When you are generating not quite enough, 20-60% (Orange)
# When you are generating barely anything, 0-20% (Red)
# Electricity is at 70%, businesses are only recieving 70% of their profits

# Happiness
# 100% Green
# 60% Orange
# 30% Red
# Happiness has decreased to 80%, residents will only tollorate 800 kgCO2

# Income
# If income drops 30% on previous year display negative
# Display messages at year 10, 25, 50, 75, 100
# If after year 50, income is below 70 display negative
# if after year 50, income is above 150 display positive


# Dictionary for each of the different conditions for each variable
	# Happines >= 100%, call neon green happiness dictionary etc etc
# Dictionary for each of the different messages that could be displayed at that level
	# Maybe 3-5 different positive messages for a neon green signal

# Iterate through and check if each dictionary is going to get called
# Separate function for checking its not displaying the same message twice
# Some function to slow down the speed of messages displayed

######################## Extra More Specific Tile Messages ########################
# If build certain tile
# Display a message about some variable on that tile
# If its a park, it could either show, residents are more happy with their new park,
# or residents are worried about maintainance of their park

# Iterate through current tiles, check for those in disrepair, current values are 20% of what
# the initial value was, display a message about that tile

# If Electricity increases by more than 50% at any time, display positive message
	# at 30%, they then build a power station, electricity is at 80%, display a message saying
	# residents are now happy that there is enough power
# If Electricity decreases by more than 60% at any time, display negative message




func add_messages():

	var currentPollution = Global.Pollution
	
	if currentPollution < prevPollution - 500:

		
		
#func add_messages():
#
	#var currentPollution = Global.Pollution
	#
	#if currentPollution < prevPollution - 500:
		#var new_good_message_index = rng.randi_range(0, good_messages.size() - 1)
		#prevPollution = currentPollution
		#while new_good_message_index == prev_good_message_index:
			#new_good_message_index = rng.randi_range(0, good_messages.size() - 1)
		#add_message(good_messages[new_good_message_index])
		#prev_good_message_index = new_good_message_index
#
	#elif currentPollution > prevPollution + 500:
		#var new_bad_message_index = rng.randi_range(0, bad_messages.size() - 1)
		#prevPollution = currentPollution
		#while new_bad_message_index == prev_bad_message_index:
			#new_bad_message_index = rng.randi_range(0, bad_messages.size() - 1)
		#add_message(bad_messages[new_bad_message_index])
		#prev_bad_message_index = new_bad_message_index
 
func show_messages():
	if is_expanded:
		update_feed(message_queue.size()) # Show all messages
		show_all_button.text = "Show Less" # Update button text
	else:
		update_feed(2) # Show only the first 2 messages
		show_all_button.text = "Show All" # Reset button text
 
func clear_feed() -> void:
	for child in v_box_container.get_children():
		if child is Label:
			child.queue_free()
 
func create_label() -> Label:
	var new_label = feed_item_scene.instantiate()
	return new_label
 
# Function to update the feed display based on how many messages to show
func update_feed(count):
	clear_feed() # Clear previous messages
	# Add the specified number of messages
	for i in range(min(count, message_queue.size())):
		var label = create_label()
		label.text = message_queue[i]
		v_box_container.add_child(label)
	# Move button to bottom of list
	v_box_container.move_child(show_all_button, -1)
 
func _on_show_all_button_button_down() -> void:
	# Toggle between collapsed (2 messages) and expanded (all messages)
	is_expanded = !is_expanded
 
func add_message(message):
	message_queue.push_front(message)
	if len(message_queue) > 5:
		message_queue.pop_back()
