extends Control
 
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
 
# Add buildings to a list
var list_of_buildings = []
func _ready() -> void:
	list_of_buildings.append($ScrollContainer/HBoxContainer/BuildingItem)
	list_of_buildings.append($ScrollContainer/HBoxContainer/Tree_Item)
 
# Assign the objects variables to modify
@export var build_menu_container: HBoxContainer
@export var build_button: MenuButton
@export var building_item: Button
@export var tree_item: Button 
@onready var build_menu_scene = load("res://scenes/building_menu.tscn")
 
# Function to hide buttons when buiod icon is pressed
var is_pressed = false
func _on_build_button_pressed() -> void:
	if is_pressed == true:
		building_item.show()
		tree_item.show()
		is_pressed = false
	else:
		building_item.hide()
		tree_item.hide()
		is_pressed = true
