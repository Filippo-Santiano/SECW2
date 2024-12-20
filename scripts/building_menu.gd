extends Control
 
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
 
# Assign the objects variables to modify
@export var PlayerController : Node2D
@export var MenuContainer : ScrollContainer
@export var Camera : Camera2D


# Hide the buttons initially
var is_pressed = false
func _ready() -> void:
	MenuContainer.hide()

# Hide the buttons when build icon is pressed
func _on_build_button_pressed() -> void:
	if is_pressed == true:
		MenuContainer.hide()
		Global.menuOpen = false
		is_pressed = false
		Camera.canScroll = true
		swap_build_mode()
	else:
		MenuContainer.show()
		Global.menuOpen = true
		is_pressed = true
		Camera.canScroll = false #Prevent the camera from scrolling while in the menu
		swap_build_mode()

func swap_build_mode():
	# If the player changes their mind, they can click the menu again
	# to exit build mode

	PlayerController.buildMode = !PlayerController.buildMode

func buttonPress(tileID):
	PlayerController.changeTile(tileID)
