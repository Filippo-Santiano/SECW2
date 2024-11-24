extends Control
 
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
 
# Assign the objects variables to modify
@export var build_menu_container: HBoxContainer
@export var build_button: MenuButton
@export var building_item: Button
@export var tree_item: Button 
@onready var build_menu_scene = load("res://scenes/building_menu.tscn")
@export var PlayerController : Node2D
 
# Control node to block interactions with map underneath building menu
var blocker: Control

# Hide the buttons initially
var is_pressed = false
func _ready() -> void:
	#Hide buttons initially
	building_item.hide()
	tree_item.hide()

# Hide the buttons when build icon is pressed
func _on_build_button_pressed() -> void:
	if is_pressed == true:
		PlayerController.buildMode = true
		building_item.hide()
		tree_item.hide()
		is_pressed = false
	else:
		PlayerController.buildMode = false
		building_item.show()
		tree_item.show()
		is_pressed = true

func _on_tree_item_pressed() -> void:
	# PlayerController.changeTile(1)
	pass

func _on_building_item_pressed() -> void:
	# PlayerController.changeTile(2)
	pass
