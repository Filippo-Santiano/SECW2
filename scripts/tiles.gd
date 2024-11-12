extends Node2D

@export var TilesLayer : TileMapLayer

# the _ underscore denotes a private variable. Get and set allow for the variable to be accessed by different
# nodes but we can limit their access. This is good practice for alleviating bugs
const LAYERS = 1

var _currentLayer = 0:
	get:
		return _currentLayer
	set(value):
		if value >= 0:
			_currentLayer = value
			

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	updatePollution()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#print(Global.Pollution)
	pass

func editTile(mode,tile,x,y):
	#layer stuff is weird, needs properly thinking about
	if _currentLayer == 0:
		TilesLayer = $Layer0
	elif _currentLayer >= LAYERS:
		TilesLayer = $Layer1
	
	if mode == "ADD":
		placeTile(tile,x,y)
		
	elif mode =="DEL":
		TilesLayer.clearTile(x,y)
		updatePollution()
	else:
		print("tried to edit tile, but mode unknown")
	#print("placed tile on",TilesLayer) #for debug

func placeTile(tile,x,y):
	if TilesLayer.get_cell_tile_data(Vector2i(x,y)) == null: #if no tile is present at those coordinates on that layer
		if $Layer0.get_cell_tile_data(Vector2i(x,y)).get_custom_data("Type") == "Ground":
			TilesLayer.placeTile(tile,x,y) #place tile.
			updatePollution()
		#this is currently living in this script so that the generic 'placeTile' function within
		#each TileMapLayer's script can still be used for the hovering tiles, plus any other instance where we might
		#need to forcibly replace a tile.
	

#Grabs every tile on a layer and sums the total pollution. Again, how necessary the layers are is worth thinking
#about. This could be fine as it is with a single layer, or a parent script that contains global variables such
#as this could sum each layer to calculate the total.
func updatePollution():
	
	var Pollution = 0
	
	for x in LAYERS+1: #Updates pollution for ALL layers by checking all current tiles
		var currentLayer = get_node("Layer"+str(x))
		var TileList = currentLayer.get_used_cells()
		for i in len(TileList):
			var NewTileData = currentLayer.get_cell_tile_data(TileList[i])
			Pollution += NewTileData.get_custom_data("Pollution")
	
	if Global.Pollution != Pollution:
		Global.Pollution = Pollution
	print(Global.Pollution)
