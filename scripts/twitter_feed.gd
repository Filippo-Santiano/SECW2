extends Control

# Eventually we will add functionality to remove the last message if the length of messages exceeds a number.
# Acts as a queue and we add new messages to the front and would remove from back.

# Array of messages to be displayed in the feed
var messages = []
var is_expanded = false # Track whether the feed is expanded to show all messages
@export var v_box_container: VBoxContainer
@export var show_all_button: Button
#@export var TilesNode: Node2D
#@onready var prevPollution = $"../../Tiles".currentPollution()
@onready var feed_item_scene = load("res://scenes/feed_item.tscn")
var prevPollution = Global.Pollution #TilesNode.currentPollution()
var pollutionChangeCount = 0

# We thought that we could also add a button to hide this entire view
# 

# Called when the node is ready
func _ready():
	pass

func _process(delta):
	add_messages()
	show_messages()
	pass
	
func add_messages():
	#var currentPollution = TilesNode.currentPollution()
	var currentPollution = Global.Pollution #$"../../Tiles".currentPollution()
	
	# Also plan to change messages after certain events/time.
	# Currently it adds a message every time pollution changes
	if prevPollution != currentPollution:
		prevPollution = currentPollution
		
		# Eventually, message types randomly selected from pool of "Bad" or "Good" messages
		if currentPollution < 300:
			add_message(str("Good Good Good Good", pollutionChangeCount))
		else:
			add_message(str("Bad ", pollutionChangeCount))
		pollutionChangeCount += 1

func show_messages():
	if is_expanded:
		update_feed(messages.size()) # Show all messages
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
	for i in range(min(count, messages.size())):
		var label = create_label()
		label.text = messages[i]
		v_box_container.add_child(label)
		
	# Move button to bottom of list
	v_box_container.move_child(show_all_button, -1)

func _on_show_all_button_button_down() -> void:
	# Toggle between collapsed (2 messages) and expanded (all messages)
	is_expanded = !is_expanded

func add_message(message):
	messages.push_front(message)
	if len(messages) > 5:
		messages.pop_back()
	
	
