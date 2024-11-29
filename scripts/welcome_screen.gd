extends Control

# Variables for continue button and how to play scene
@onready var continue_button: Button = $continue_button
@onready var how_to_play = preload("res://scenes/how_to_play.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Switch to 'how_to_play' scene when 'continue_button' pressed
func on_continue_pressed():
	get_tree().change_scene_to_packed(how_to_play)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
# Create connection for continue button
func handle_connecting_signals() -> void:
	continue_button.button_down.connect(on_continue_pressed)
