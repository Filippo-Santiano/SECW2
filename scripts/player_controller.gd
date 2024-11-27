extends Node2D

# @export makes a variable visible in the inspector for editing. In this case, we can export 'TilesNode'
# and then go through the editor to point to our 'Tiles' node. This is the best way to access different nodes in
# code as it means less code changes when refactoring

@export var TilesNode : Node2D
@export var HoverTiles : TileMapLayer
@export var TextLabel : Label

@export var buildMode = false #player can only place and delete tiles when build mode is active (true)


var currentTile = 1
var activeLayer = 1

# these vars just add a delay between pressing the build button and being able to build
var time_passed = 0.0
var delay = 0.5  # 0.5 seconds

#activeLayer controls which layer (GrassLayer,BuildingLayer) the user is placing the tiles on.
#Currently we have this set to 1 and may find that we don't need to edit 0 (grass etc.) directly at all.

var _HoverTilePosition = Vector2i(0,0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	TilesNode.set("_currentLayer",activeLayer) #set the initial tile layer as soon as possible to avoid weirdness
	

#Called every 'physics' frame which, ideally, runs at x frames per second regardless of the game's actual framerate.
#Most actual processing should either go on in here, or in _process with manipulation of delta time to maintain consistent speed.
func _physics_process(delta: float) -> void:
	# When build button pressed, begin delay so buildings cannot be immediately placed 
	if buildMode:
		time_passed += delta
		if time_passed >= delay:
			allInputs()
			hoverTiles(false)
	else:
		time_passed = 0
		hoverTiles(false) # remove hover tile if build mode is false
	
#I like to have a function that contains all of my Input events
#This gets called every frame in _physics_process()
#There are ways to make this more efficient, triggering things on an Input instead of constantly checking every
#frame. But works for the time being and I haven't yet ran into an issue with this approach
func allInputs():
	if Input.is_action_just_pressed("lmb"):
		editTile("ADD")
	if Input.is_action_just_pressed("mmb"):
		editTile("DEL")
	if Input.is_action_just_pressed("ui_accept"):
		changeTile()
		hoverTiles(true)

func mouseInputToTileMap():
	#Takes the mouse location and returns coordinates in terms of the tilemap - very important for placing tiles,
	#showing which time the user is hovering over etc.
	var currentMousePosition = get_global_mouse_position()
	var currentTilePosition = TilesNode.TilesLayer.local_to_map(currentMousePosition)
	
	return currentTilePosition

func editTile(mode):
	TilesNode.set("_currentLayer",activeLayer) #Sets the layer to place the tile onto. Should be dependent on the type
	#of tile?
	var TilePosition = mouseInputToTileMap()
	
	TilesNode.editTile(mode,currentTile,TilePosition.x,TilePosition.y) #places a tile of ID currentTile at the mouse position

func changeTile():
	#Right now we just toggle between 1 and 0 since we only have two tiles.
	#Eventually we'd be moving through a list (list of dictionaries would be ideal, then could be
	# Tiles[0].ID // possibly we'd just assume the ID is the item index
	if currentTile > 1:
		currentTile = 1
		activeLayer = 1
	else:
		currentTile += 1
		activeLayer = 1

func hoverTiles(override):
	#HoverTiles.set_cell(mouseInputToTileMap(),currentTile,Vector2i(0,0),0)
	if buildMode:
		if _HoverTilePosition != mouseInputToTileMap() or override:
			HoverTiles.clearTile(_HoverTilePosition.x,_HoverTilePosition.y)
			_HoverTilePosition = mouseInputToTileMap()
			HoverTiles.placeTile(currentTile,_HoverTilePosition.x,_HoverTilePosition.y)
	else:
		HoverTiles.clearTile(_HoverTilePosition.x,_HoverTilePosition.y)
	#If the mouse position has changed since the last iteration,
	#clear the previous tile and then draw the new one.
	#This is just for the visual effect of seeing the tile before you place it-
	#not that important.   Could also make it check whether there's already a tile there -
	#that could go in the general placeTile function in the TilesLayer script
	
func setLabel():
	#Quick way of showing info on the screen. TEMPORARY. We want nice UI
	var textToDisplay = str("Selected Tile: ", currentTile,"\n")
	TextLabel.set("text",textToDisplay)
