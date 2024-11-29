extends Button
@export var ID : int
@export var BuildingMenu : Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pressed.connect(_setID)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _setID():
	BuildingMenu.buttonPress(ID)
