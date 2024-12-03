class_name ExtrasMenu
extends Control

@onready var BackButton: Button = $PanelContainer2/VBoxContainer/BackButton
@onready var data_references: DataMenu = $DataReferences
@onready var data_button: Button = $PanelContainer2/VBoxContainer/DataButton
@onready var panel_container_2: PanelContainer = $PanelContainer2

signal exit_extras_menu

func _ready() -> void:
	handle_connecting_signals()
	BackButton.button_down.connect(on_exit_pressed)
	set_process(false)
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


# Function for displaying current stats
func _on_current_stats_pressed() -> void:
	pass # Replace with function body.


func on_data_references_pressed() -> void:
	panel_container_2.visible = false
	data_references.set_process(true)
	data_references.visible = true


	
func on_exit_pressed() -> void:
	exit_extras_menu.emit()
	set_process(false)
	
func on_exit_data_menu() -> void:
	data_references.visible = false
	panel_container_2.visible = true
	
func handle_connecting_signals() -> void:
	data_button.button_down.connect(on_data_references_pressed)
	data_references.exit_data_references_menu.connect(on_exit_data_menu)
	
