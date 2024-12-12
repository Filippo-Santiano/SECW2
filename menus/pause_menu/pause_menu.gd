extends Control

@onready var extras_menu: ExtrasMenu = $ExtrasMenu
@onready var panel_container: PanelContainer = $PanelContainer
@onready var resume_button: Button = $PanelContainer/VBoxContainer/Resume
@onready var extras_button: Button = $PanelContainer/VBoxContainer/Extras
@onready var quit_button: Button = $PanelContainer/VBoxContainer/Quit
@onready var help_button : Button = $PanelContainer/VBoxContainer/Help
@onready var help_menu: HelpMenu = $HelpMenu

var game_paused = false

func _ready() -> void:
	# Connect button signals
	resume_button.button_down.connect(_on_resume_pressed)
	extras_button.button_down.connect(_on_extras_pressed)
	help_button.button_down.connect(_on_help_pressed)
	quit_button.button_down.connect(_on_quit_pressed)

	# Connect child menu signals
	extras_menu.exit_extras_menu.connect(_on_exit_submenu)

func _process(delta):
	if Input.is_action_just_pressed("esc"):
		if game_paused:
			resume()  # Unpause the game if it's already paused
		else:
			pause()  # Pause the game if it's not paused yet

func pause():
	game_paused = true
	reset_menus()  # Reset all child menus
	panel_container.visible = true  # Show the main pause menu
	visible = true
	get_tree().paused = true
	$AnimationPlayer.play("blur")  

func resume():
	game_paused = false
	reset_menus()  # Hide all menus
	visible = false
	get_tree().paused = false  # Resume the game
	$AnimationPlayer.play_backwards("blur")  # Remove blur effect

func reset_menus() -> void:
	extras_menu.hide_menu()  # Ensure ExtrasMenu is hidden
	help_menu.hide_menu()
	panel_container.visible = true  # Show the main pause menu

func _on_resume_pressed() -> void:
	resume()  # Resume game when "Resume" is pressed

func _on_quit_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://menus/main_menu/main_menu.tscn")  # Go to the main menu when quitting

func _on_extras_pressed() -> void:
	panel_container.visible = false
	extras_menu.show_menu()  # Show the Extras menu

func _on_help_pressed() -> void:
	panel_container.visible = false
	help_menu.show_menu()  # Show the Extras menu

func _on_exit_submenu() -> void:
	# Called when exiting any submenu
	extras_menu.hide_menu()  # Hide Extras menu
	help_menu.hide_menu()  # Hide Extras menu
	panel_container.visible = true  # Show the main pause menu

func _on_help_menu_exit_help_menu() -> void:
	_on_exit_submenu()
