class_name DataMenu
extends Control

@onready var back_button: Button = $PanelContainer/VBoxContainer/BackButton

signal exit_data_references_menu

func _ready() -> void:
	back_button.button_down.connect(_on_back_pressed)
	set_process(false)
	visible = false

func show_menu() -> void:
	set_process(true)
	visible = true

func hide_menu() -> void:
	set_process(false)
	visible = false

func _on_back_pressed() -> void:
	emit_signal("exit_data_references_menu")
