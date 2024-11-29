extends Control

# Variables for continue button and main scence
@onready var continue_button: Button = $ContinueButton
@onready var main_scence = preload("res://scenes/main.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Change to main scence
func on_continue_pressed():
	get_tree().change_scene_to_packed(main_scence)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# Create connection for continue button
func handle_connecting_signals() -> void:
	continue_button.button_down.connect(on_continue_pressed)
