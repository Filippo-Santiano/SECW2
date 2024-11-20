extends Camera2D

const MOVE_SPEED = 20

var startPos = Vector2()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	startPos = position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	var Inputs = getInputs()

	position += Inputs * MOVE_SPEED
	
	if Input.is_action_just_pressed("R"):
		reset()

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
	
	return Inputs.normalized()

func reset():
	position = startPos
