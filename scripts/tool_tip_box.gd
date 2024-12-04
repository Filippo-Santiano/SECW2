extends Panel

@export var button : Button
var buttonMode = 0
var currentStep = 1
var following = false
var mouseFocus = false
const STEPS = [1.5,1,0.9]

signal repair_button_pressed

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	modulate = Color(0,0,0,0)
	hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	scale.x = lerp(scale.x,float(STEPS[currentStep]),0.03)
	scale.y = lerp(scale.x,float(STEPS[currentStep]),0.01)
	#lerp from the old value to the new one, scaling the box

func set_text(text,property):
	find_child(property).text = str(text) #set the text
	
func set_repair(text,property):
	find_child(property).get_node("RepairLabel").text = str(text)

func cameraScale(step):
	currentStep = step #Camera calls this function to tell the box the current zoom level
	
func showToolTip():
	show()
	$AnimationPlayer.play("showToolTipBox")
	#Play the animation that fades the box in

func hideToolTip():
	if not mouseFocus:
		buttonMode = 0
		$AnimationPlayer.play_backwards("showToolTipBox")
		#Play the same animation, backwards (fade out)
		await($AnimationPlayer.animation_finished)
		#Wait for it to finish, then make sure the box is properly hidden
		hide()

func changeButtonText(mode):
	if mode:
		button.get_node("Repair").text = "Confirm"
	else:
		button.get_node("Repair").text = "View Repair"

#func changeButtonText(text):
	#button.get_node("Repair").text = text
		
func changeCost(cost):
	button.get_node("Cost").text = cost

func _on_button_pressed() -> void:
	emit_signal("repair_button_pressed")


func _on_mouse_blocker_mouse_entered() -> void:
	mouseFocus = true


func _on_mouse_blocker_mouse_exited() -> void:
	mouseFocus = false
