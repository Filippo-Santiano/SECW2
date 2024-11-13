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
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func editTile(mode,tile,x,y):
	#layer stuff is weird, needs properly thinking about
	if _currentLayer == 0:
		TilesLayer = $Layer0
	elif _currentLayer >= LAYERS:
		TilesLayer = $Layer1
	
	if mode == "ADD":
		placeTile(tile,x,y)
		updatePollution()
	elif mode =="DEL":
		TilesLayer.clearTile(x,y)
		updatePollution()
	else:
		print("tried to edit tile, but mode unknown")
	#print("placed tile on",TilesLayer) #for debug

func placeTile(tile,x,y):
	if TilesLayer.get_cell_tile_data(Vector2i(x,y)) == null: #if no tile is present at those coordinates on that layer
		TilesLayer.placeTile(tile,x,y) #place tile.
		#this is currently living in this script so that the generic 'placeTile' function within
		#each TileMapLayer's script can still be used for the hovering tiles, plus any other instance where we might
		#need to forcibly replace a tile.
	

#Grabs every tile on a layer and sums the total pollution. Again, how necessary the layers are is worth thinking
#about. This could be fine as it is with a single layer, or a parent script that contains global variables such
#as this could sum each layer to calculate the total.
func updatePollution():
	var TileList = TilesLayer.get_used_cells()
	var Pollution = 0
	
	for i in len(TileList):
		var NewTileData = TilesLayer.get_cell_tile_data(TileList[i])
		Pollution += NewTileData.get_custom_data("Pollution")
	
	if Global.Pollution != Pollution:
		Global.Pollution = Pollution
	
	print(Global.Pollution)
	
## Handles input for clicking tiles and displaying popup info
func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		var world_pos = get_global_mouse_position()
		var tile_pos = TilesLayer.local_to_map(world_pos)
		# Retrieve tile ID and information
		var tile_id = get_tile_id(tile_pos)
		if tile_id != -1: # Check if a tile exists at the position
			show_popup(tile_pos, tile_id)

# Shows the popup with tile information
func show_popup(tile_pos: Vector2i, tile_id: int):
	var popup = get_node("../CanvasLayer/Popup")
	
	# Customize popup content with tile details
	popup.get_node("Label").text = "Building at: %s \n (ID: %d)" % [tile_pos, tile_id]
	
	# Show and center the popup
	popup.popup_centered()
# Shows the popup with tile information
	

# Custom method to get a tile ID
func get_tile_id(tile_pos: Vector2i) -> int:
	var tile_id = TilesLayer.get_cell_source_id(Vector2i(tile_pos.x, tile_pos.y))
	return tile_id if tile_id != -1 else -1 # Return the tile ID or -1 if no tile is present 
