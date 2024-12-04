extends Control

@onready var stats_screen = preload("res://scenes/end_screen.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Go to stats screen when 'Next' button pressed
func _on_next_button_pressed() -> void:
	get_tree().change_scene_to_packed(stats_screen)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
