extends Button
@export var ID : int
@export var BuildingMenu : Control
@onready var tile_set = preload("res://scenes/tileset.tres")

var tileData
var cost

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pressed.connect(_setID)
	tileData = tile_set.get_source(ID).get_tile_data(Vector2i(0,0),0)
	cost = tileData.get_custom_data("Cost")
	$Cost.text = str("£",cost)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _setID():
	BuildingMenu.buttonPress(ID)
