class_name HelpMenu
extends Control

@onready var back_button: Button = $PanelContainer/VBoxContainer/Back

signal exit_help_menu

func _ready() -> void:
	back_button.button_down.connect(_on_back_help_pressed)
	set_process(false)
	visible = false

func show_menu() -> void:
	set_process(true)
	visible = true

func hide_menu() -> void:
	set_process(false)
	visible = false

func _on_back_help_pressed() -> void:
	emit_signal("exit_help_menu")
