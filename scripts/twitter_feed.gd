extends Control
 
# Eventually we will add functionality to remove the last message if the length of messages exceeds a number.
 
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

func add_messages():

	var currentPollution = Global.Pollution
	
	if currentPollution < prevPollution - 500:
		var new_good_message_index = rng.randi_range(0, good_messages.size() - 1)
		prevPollution = currentPollution
		while new_good_message_index == prev_good_message_index:
			new_good_message_index = rng.randi_range(0, good_messages.size() - 1)
		add_message(good_messages[new_good_message_index])
		prev_good_message_index = new_good_message_index

	elif currentPollution > prevPollution + 500:
		var new_bad_message_index = rng.randi_range(0, bad_messages.size() - 1)
		prevPollution = currentPollution
		while new_bad_message_index == prev_bad_message_index:
			new_bad_message_index = rng.randi_range(0, bad_messages.size() - 1)
		add_message(bad_messages[new_bad_message_index])
		prev_bad_message_index = new_bad_message_index
 
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
