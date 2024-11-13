extends Popup
 
 
#@onready var window: Window = $CanvasLayer/Popup/Window
 
@onready var label: Label = $CanvasLayer/Popup/Label
 
# Method to display building information
 
func show_info(info: String):
	label.text = info # Update the text of the Label
	self.popup_centered() # Show the popup and center it on the screen
 
# Handle button press event to close the popup
func _on_Button_pressed():
	self.hide() # Hide the popup
