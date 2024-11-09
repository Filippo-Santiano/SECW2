extends Node2D

@export var TilesLayer : TileMapLayer

# the _ underscore denotes a private variable. Get and set allow for the variable to be accessed by different
# nodes but we can limit their access. This is good practice for alleviating bugs
var _currentLayer = 0:
	get:
		return _currentLayer
	set(value):
		if value >= 0:
			_currentLayer = value
			

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func editTile(mode,tile,x,y):
	
	#layer stuff is weird, needs properly thinking about
	if _currentLayer == 0:
		TilesLayer = $GrassLayer
	elif _currentLayer >= 1:
		TilesLayer = $BuildingLayer
	
	if mode == "ADD":
		TilesLayer.placeTile(tile,x,y)
	elif mode =="DEL":
		TilesLayer.clearTile(x,y)
	else:
		print("tried to edit tile, but mode unknown")
	#print("placed tile on",TilesLayer) #for debug
	print(currentPollution())
	
#Grabs every tile on a layer and sums the total pollution. Again, how necessary the layers are is worth thinking
#about. This could be fine as it is with a single layer, or a parent script that contains global variables such
#as this could sum each layer to calculate the total.
func currentPollution():
	var TileList = TilesLayer.get_used_cells()
	var LayerPollution = 0
	for i in len(TileList):
		var NewTileData = TilesLayer.get_cell_tile_data(TileList[i])
		LayerPollution += NewTileData.get_custom_data("Pollution")
	return LayerPollution
