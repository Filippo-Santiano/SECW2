class_name MainMenu
extends Control

@onready var start_button: Button = $MarginContainer/HBoxContainer/VBoxContainer/Start_Button
@onready var options_button: Button = $MarginContainer/HBoxContainer/VBoxContainer/Options_Button
@onready var exit_button: Button = $MarginContainer/HBoxContainer/VBoxContainer/Exit_Button
# @onready var start_game = preload("res://scenes/main.tscn")
@onready var welcome_screen = preload("res://scenes/welcome_screen.tscn")
@onready var options_menu: OptionMenu = $Options_Menu
@onready var margin_container: MarginContainer = $MarginContainer


func _ready() -> void:
	handle_connecting_signals()

func on_start_pressed() -> void:
	get_tree().change_scene_to_packed(welcome_screen)

func on_options_pressed() -> void:
	margin_container.visible = false
	options_menu.set_process(true)
	options_menu.visible = true

func on_exit_pressed() -> void:
	get_tree().quit()
	
func on_exit_options_menu() -> void:
	margin_container.visible = true
	options_menu.visible = false

func handle_connecting_signals() -> void:
	start_button.button_down.connect(on_start_pressed)
	options_button.button_down.connect(on_options_pressed)
	exit_button.button_down.connect(on_exit_pressed)
	options_menu.exit_options_menu.connect(on_exit_options_menu)
