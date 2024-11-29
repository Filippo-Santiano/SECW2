extends Control

# Initialise Dictionaries
var conditions = {}
var messages = {}
var triggered_conditions = {}
var message_history = {}

# Queue of messages to be displayed in the feed
var message_queue = []
var rng = RandomNumberGenerator.new()

# Need to add in a new way of randomising

var is_expanded = false # Track whether the feed is expanded to show all messages
@export var v_box_container: VBoxContainer
@export var show_all_button: Button
@onready var feed_item_scene = load("res://scenes/feed_item.tscn")
@export var MessageDelay: Timer
@onready var check = Conditions.new()

var prevPollution = Global.Pollution

# We thought that we could also add a button to hide this entire view

func _ready():
	check = Conditions.new()
	add_child(check)
	# Add the different conditions
	conditions = {
		"Pollution": {
			"pos_to_neg": check.poll_pos_to_neg,
			"half_thresh": check.poll_half_thresh,
		},
		"Happiness": {
			"low": check.happ_low,
			"high": check.happ_high,
		},
	}
	messages = {
		"Pollution": {
			"pos_to_neg": [
				"Pollution has dropped below zero! Great job!",
				"The city celebrates achieving a carbon-neutral status!"
			],
			"half_thresh": [
				"Pollution is halfway to the threshold! Be cautious!",
				"Environmental concerns rise as pollution nears dangerous levels."
			],
		},
		"Happiness": {
			"low": [
				"Happiness is dangerously low. Residents are unhappy!",
				"Citizens demand better living conditions as happiness plummets."
			],
			"high": [
				"Happiness is at an all-time high!",
				"Residents are thrilled with recent improvements!"
			],
		},
	}
	for variable in conditions.keys():
		triggered_conditions[variable] = ""
		message_history[variable] = {}
	
	MessageDelay.wait_time = 2.0
	MessageDelay.connect("timeout", Callable(self, "_on_message_timeout"))
	if message_queue.size() > 0:
		MessageDelay.start()


func _process(delta):
	check_conditions()
	show_messages()
	pass


func check_conditions():
	for variable in conditions.keys():
		var current_condition = triggered_conditions[variable]
		var new_condition = ""
		for condition in conditions[variable].keys():
			if conditions[variable][condition].call():
				new_condition = condition
				break
		if new_condition != current_condition:
			triggered_conditions[variable] = new_condition
			if new_condition != "":
				queue_message(variable, new_condition)


func queue_message(variable: String, condition: String):
	var available_messages = messages[variable][condition]
	var prev_message = message_history[variable].get(condition, null)
	
	var new_message = available_messages[rng.randi_range(0, available_messages.size() - 1)]
	while available_messages.size() > 1 and new_message == prev_message:
		new_message = available_messages[rng.randi_range(0, available_messages.size() - 1)]
	
	message_queue.push_back(new_message)
	message_history[variable][condition] = new_message
	
	#if not MessageDelay.is_active() and message_queue.size() > 0:
		#MessageDelay.start()


func on_message_timeout():
	if message_queue.size()>0:
		var message = message_queue.pop_front()
		add_to_feed(message)
	if message_queue.size()>0:
		MessageDelay.start()
	else:
		MessageDelay.stop()

func add_to_feed(message: String):
	var label = create_label()
	label.text = message
	v_box_container.add_child(label)
	v_box_container.move_child(show_all_button, -1)

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
		label.text = message_queue[message_queue.size() - 1 - i]
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
