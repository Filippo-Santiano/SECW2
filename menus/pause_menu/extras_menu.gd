class_name ExtrasMenu
extends Control

@onready var data_references: DataMenu = $DataReferences
@onready var back_button: Button = $PanelContainer2/VBoxContainer/BackButton
@onready var data_button: Button = $PanelContainer2/VBoxContainer/DataButton
@onready var panel_container_2: PanelContainer = $PanelContainer2
@onready var current_stats: Button = $PanelContainer2/VBoxContainer/CurrentStats

signal exit_extras_menu

func _ready() -> void:
	# Connect button signals
	back_button.button_down.connect(_on_back_pressed)
	data_button.button_down.connect(_on_data_button_pressed)

	# Connect submenu signals
	data_references.exit_data_references_menu.connect(on_exit_data_menu)

	set_process(false)
	visible = false

func show_menu() -> void:
	set_process(true)
	visible = true
	panel_container_2.visible = true

func hide_menu() -> void:
	set_process(false)
	visible = false
	panel_container_2.visible = true  # Reset state when hidden
	data_references.hide_menu()

func _on_back_pressed() -> void:
	emit_signal("exit_extras_menu")

func _on_data_button_pressed() -> void:
	panel_container_2.visible = false
	data_references.show_menu()

func on_exit_data_menu() -> void:
	data_references.hide_menu()
	panel_container_2.visible = true
