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
			"poll_greater_thresh": check.poll_greater_thresh,
		},
		"Happiness": {
			"low": check.happ_low,
			"high": check.happ_high,
		},
		"Income": {
			"drop_30": check.income_30,
			"drop_50": check.income_50,
			"growth_above_150": check.inc_growth_above_150,
			"below_200_after_50": check.inc_below_200_after_50,
			"above_200_after_50": check.inc_above_200_after_50,
		},
		"Electricity": {
			"over_160": check.elec_over_160,
			"over_100": check.elec_over_100,
			"adequate": check.elec_adequate,
			"under_20": check.elec_under_20,
		},
		"YearlyPollution": {
			"strong_negative": check.yp_strong_negative,
			"negative": check.yp_negative,
			"strong_postive": check.yp_strong_postive,
			"positive": check.yp_positive,
		},
	}
	# Messages to show after conditions match
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
			"poll_greater_thresh": [
				"Pollution is greater than threshold please look out for the city."
			]
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
		"Income": {
			"drop_30": [
				"Income has dropped over 30% compared to last year! This is a significant concern.",
				"The economy is in a decline. We need to focus on sustainable growth to recover."
			],
			"drop_50": [
				"Income has fallen by over 50% since last year! This is a critical situation for the city's economy.",
				"The city's income has taken a severe hit. Immediate economic intervention is needed."
			],
			"growth_above_150": [
				"Income has grown by over 150%! The city's economy is booming!",
				"The city's economy is flourishing. Investments in innovation are paying off."
			],
			"below_200_after_50": [
				"After 50 years, income has is particularly weak. The city needs to invest in future technologies and sustainable growth.",
				"Income levels have stagnated after 50 years. New economic strategies are required."
			],
			"above_200_after_50": [
				"After 50 years, income has is particularly strong. The city is prospering!",
				"Economic strategies are finally paying off."
			],
		},
		"Electricity": {
			"over_160": [
				"The city is generating an excess of electricity! This is a huge win for renewable energy.",
				"Electricity generation is way beyond the demand! Consider storing or exporting energy."
			],
			"over_100": [
				"The city is generating more electricity than needed. Green energy is thriving!",
				"Electricity generation is stable and exceeding demand. Good work on sustainability."
				],
			"adequate": [
				"Electricity generation is stable, but we must keep an eye on future needs.",
				"Electricity generation is adequate, but future investments in renewables are necessary."
			],
			"under_20": [
				"Electricity generation is critically low. Immediate action needed to boost renewable sources.",
				"The city's electricity supply is at risk. We need urgent action to stabilize the grid."
			]	
		},
		"YearlyPollution": {
			"strong_negative": [
				"Pollution has increased significantly! The city is in a dangerous state.",
				"Pollution is worsening at an alarming rate. Urgent measures are required."
			],
			"negative": [
				"Pollution levels are still rising. Strong environmental policies needed.",
				"Pollution has increased by 50%. Time to act now!"
			],
			"positive": [
				"Pollution is reducing! Keep up the good work with green initiatives.",
				"Pollution has decreased by 50%! Let's continue the progress."
			],
			"strong_positive": [
				"Pollution has reduced by a significant amount. The city is becoming cleaner!",
				"The city's pollution levels have dropped significantly. Keep it up!"
			]
		},
	}
# Initialized triggered_conditions and message_history dictionaries
	for variable in conditions.keys():
		triggered_conditions[variable] = ""
		message_history[variable] = {}
		
# Setting message delay for 3 seconds and connecting signal for timeout
	MessageDelay.wait_time = 3.0
	MessageDelay.connect("timeout", Callable(self, "_on_message_timeout"))
	if message_queue.size() > 0:
		MessageDelay.start() #Starting message delay if there are messages in the queue



func _process(delta):
	if Global.currentYear > 2: # Process conditions and update feed after a certain year
		age_over()
		check_conditions()
		show_messages()
	pass

# Functions to check if any conditions are met or not
func check_conditions():
	# Iterate over all conditions keys
	for variable in conditions.keys():
		var current_condition = triggered_conditions[variable]
		var new_condition = ""
		# Check each condition for the variable
		for condition in conditions[variable].keys():
			if conditions[variable][condition].call():
				new_condition = condition
				break
	# If the condition has changed, update and queue a new message
		if new_condition != current_condition:
			triggered_conditions[variable] = new_condition
			if new_condition != "":
				queue_message(variable, new_condition)

var years_messages_triggered = {}

# Function to check the age-over condition and trigger messages
func age_over():
	# Check if a message has already been triggered for this year threshold
	if not years_messages_triggered.has(Global.Years_Over):
		# Trigger appropriate messages based on the current Global.Years_Over value
		if Global.Years_Over == 1:
			message_queue.push_back("Warning, above the threshold. You have 2 years left")
			# Marked the year threshold as processed (message triggered)
			years_messages_triggered[Global.Years_Over] = true
		elif Global.Years_Over == 2:
			message_queue.push_back("Warning, above the threshold. You have 1 year left")
			# Marked the year threshold as processed (message triggered)
			years_messages_triggered[Global.Years_Over] = true
		elif Global.Years_Over == 0:
			years_messages_triggered.clear()
		else:
			pass


# Function to queue a message based on the condition and variable
func queue_message(variable: String, condition: String):
	var available_messages = messages[variable][condition]
	var prev_message = message_history[variable].get(condition, null) # Get the last message for this condition
	# Randomly selecting a new message for  avoiding repetition
	var new_message = available_messages[rng.randi_range(0, available_messages.size() - 1)]
	while available_messages.size() > 1 and new_message == prev_message:
		new_message = available_messages[rng.randi_range(0, available_messages.size() - 1)]
	
	message_queue.push_back(new_message) # Add the new message to the queue
	message_history[variable][condition] = new_message


# Called when message delay timer times out
func on_message_timeout():
	if message_queue.size()>0:
		var message = message_queue.pop_front() # Geting the next message from the queue
		add_to_feed(message) # Adding the message to the feed
	if message_queue.size()>0:
		MessageDelay.start()
	else:
		MessageDelay.stop() # Stopping the timer if no more messages

func add_to_feed(message: String):
	var label = create_label()
	label.text = message
	v_box_container.add_child(label)
	v_box_container.move_child(show_all_button, -1)

func show_messages():
	if is_expanded:
		update_feed(5) # Show all messages
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
