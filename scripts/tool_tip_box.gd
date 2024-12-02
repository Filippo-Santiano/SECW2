extends Panel

@export var label : Label
@export var camera : Camera2D

@onready var prevPos = camera.position

var currentStep = 1
var following = false
const STEPS = [1.5,1,0.9]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	scale.x = lerp(scale.x,float(STEPS[currentStep]),0.03)
	scale.y = lerp(scale.x,float(STEPS[currentStep]),0.01)
	#lerp from the old value to the new one, scaling the box

func set_text(text):
	label.text = text #set the text

func cameraScale(step):
	currentStep = step #Camera calls this function to tell the box the current zoom level
	
func showToolTip():
	show()
	$AnimationPlayer.play("showToolTipBox")
	#Play the animation that fades the box in

func hideToolTip():
	$AnimationPlayer.play_backwards("showToolTipBox")
	#Play the same animation, backwards (fade out)
	await($AnimationPlayer.animation_finished)
	#Wait for it to finish, then make sure the box is properly hidden
	hide()
