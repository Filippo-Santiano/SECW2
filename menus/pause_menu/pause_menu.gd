extends Control

#@onready var start_button: Button = $MarginContainer/HBoxContainer/VBoxContainer/Start_Button
#@onready var options_button: Button = $MarginContainer/HBoxContainer/VBoxContainer/Options_Button
#@onready var exit_button: Button = $MarginContainer/HBoxContainer/VBoxContainer/Exit_Button
# @onready var start_game = preload("res://scenes/main.tscn")
@onready var extras_menu: ExtrasMenu = $ExtrasMenu
@onready var pause_menu: Control = $"."
@onready var extras: Button = $PanelContainer/VBoxContainer/Extras
@onready var panel_container: PanelContainer = $PanelContainer


func _ready() -> void:
	handle_connecting_signals()

# Called when the node enters the scene tree for the first time.
func resume():
	get_tree().paused = false
	visible = false
	$AnimationPlayer.play_backwards("blur")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func pause():
	extras_menu.visible = false
	visible = true
	get_tree().paused = true
	$AnimationPlayer.play("blur")

func testEsc():
	if Input.is_action_just_pressed("esc") and !get_tree().paused:
		pause()
	elif Input.is_action_just_pressed("esc") and get_tree().paused:
		resume()


func _on_resume_pressed() -> void:
	resume()

func _on_quit_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://menus/main_menu/main_menu.tscn")

func _process(delta):
	testEsc()

func _on_extras_pressed() -> void:
	panel_container.visible = false
	print("Extras button pressed")
	extras_menu.set_process(true)
	extras_menu.visible = true
	

func on_exit_extras_menu() -> void:
	extras_menu.visible = false
	panel_container.visible = true

func handle_connecting_signals() -> void:
	extras.button_down.connect(_on_extras_pressed)
	extras_menu.exit_extras_menu.connect(on_exit_extras_menu)
	
