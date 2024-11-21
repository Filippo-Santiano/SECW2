extends Node2D
var currentLayer : TileMapLayer
@export var sprite : Sprite2D

signal waited
var waiting = false
var initialYear = 0
var timeToBuild = 0
@onready var Tiles = get_parent()
const IN_PROGRESS_ID = 26

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if waiting:
		wait()

func initialise(layer,year,buildTime):
	currentLayer = layer
	initialYear = year
	timeToBuild = buildTime

func wait():
	if Global.currentYear >= initialYear + timeToBuild: #if enough years have passed, waiting complete. Right now the years
		emit_signal("waited")							#are counted in 1s and thus even though a building takes 0.5 years, we can
		waiting = false									#only place after a year has gone by. Need to adjust the YearsTimer to combat this

func addNewTile(tile):
	var new_tile = Tile.new()
	new_tile.id = tile
	new_tile.initialise_pollution()
	new_tile.initialise_income()
	Global.placed_tiles.append(new_tile)

func updateData():
	Tiles.updatePollution()
	Tiles.updateIncome()

func place(tile,x,y):
	if timeToBuild > 0:
		currentLayer.placeTile(IN_PROGRESS_ID,x,y) #Place the construction (in progress) building tile
		print("Placed construction tile on layer ", currentLayer, " ID: ", IN_PROGRESS_ID, " at",Vector2i(x,y))
		waiting = true #Begins the wait function (runs in _process())
		await(waited) #waits for the signal from the wait function that says we have finished waiting
		currentLayer.clearTile(x,y) #delete the construction tile and 
		currentLayer.placeTile(tile,x,y) #place the real one
	else:
		currentLayer.placeTile(tile,x,y)
	
	updateData()
	queue_free()
