extends Camera2D

const MOVE_SPEED = 20
const ZOOM_STEPS = [1.0,1.5,2.0]

@export var WorldBounds : Area2D
@export var ToolTipBox : Panel

var currentStep = 1
var startPos = Vector2()
var startZoom = Vector2()
var zoomDirection = 1
var prevPos
var canScroll = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	startPos = position
	prevPos = startPos
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	
	if WorldBounds in $CameraCollider.get_overlapping_areas(): #If the camera is currently within the WorldBounds area
		prevPos = position
		
		var Inputs = getInputs()
		position += Inputs * MOVE_SPEED
		zoom = lerp(zoom,Vector2(ZOOM_STEPS[currentStep],ZOOM_STEPS[currentStep]),0.1)
	else:
		position = prevPos

func getInputs():
	
	var Inputs = Vector2(0,0)
	
	if Input.is_action_pressed("W"):
		Inputs.y = -1
	elif Input.is_action_pressed("S"):
		Inputs.y = 1
	else:
		Inputs.y = 0
	
	if Input.is_action_pressed("A"):
		Inputs.x = -1
	elif Input.is_action_pressed("D"):
		Inputs.x = 1
	else:
		Inputs.x = 0
		#WASD controls the camera direction. If not presssing any buttons, direction 0.
		
	if Input.is_action_just_pressed("R"):
		reset() #R resets to original position
	
	if canScroll:
		if Input.is_action_just_pressed("scroll up") and currentStep < len(ZOOM_STEPS)-1:
			currentStep += 1
			ToolTipBox.cameraScale(currentStep)
		elif Input.is_action_just_pressed("scroll down") and currentStep > 0:
			currentStep -= 1
			ToolTipBox.cameraScale(currentStep)
		#Scroll wheel scrolls between three zoom steps set at the top of this script
	
	return Inputs.normalized()

func reset():
	position = startPos
