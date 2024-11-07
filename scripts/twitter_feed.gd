extends Control

# Eventually we will add functionality to remove the last message if the length of messages exceeds a number.
# Acts as a queue and we add new messages to the front and would remove from back.

# Array of messages to be displayed in the feed
var messages = ["Message 1", "Message 2", "Message 3", "Message 4", "Message 5"]
var is_expanded = false # Track whether the feed is expanded to show all messages
@onready var v_box_container: VBoxContainer = $ScrollContainer/VBoxContainer
@onready var show_all_button: Button = $ScrollContainer/VBoxContainer/ShowAllButton

# Called when the node is ready
func _ready():
	# Initially display only the first 2 messages
	update_feed(2)

func clear_feed() -> void:
	for child in v_box_container.get_children():
		if child is Label:
			child.queue_free()
			

# Function to update the feed display based on how many messages to show
func update_feed(count):
	clear_feed() # Clear previous messages
	
	# Add the specified number of messages
	for i in range(min(count, messages.size())):
		var label = Label.new()
		label.text = messages[i]
		v_box_container.add_child(label)
		
	v_box_container.move_child(show_all_button, -1)

func _on_show_all_button_button_down() -> void:
	# Toggle between collapsed (2 messages) and expanded (all messages)
	is_expanded = !is_expanded
	print(is_expanded)
	if is_expanded:
		update_feed(messages.size()) # Show all messages
		for child in v_box_container.get_children():
			print(child)
		show_all_button.text = "Show Less" # Update button text
	else:
		update_feed(2) # Show only the first 2 messages
		show_all_button.text = "Show All" # Reset button text

func add_message(message):
	messages.push_front(message)
	if len(messages) > 5:
		messages.pop_back()
	
	
