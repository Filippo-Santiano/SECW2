class_name DataMenu

extends Control

@onready var BackButton: Button = $PanelContainer/VBoxContainer/BackButton

signal exit_data_references_menu

func _ready() -> void:
	BackButton.button_down.connect(on_exit_pressed)
	set_process(false)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func on_exit_pressed() -> void:
	print("Exiting data references menu")
	exit_data_references_menu.emit()
	set_process(false)
