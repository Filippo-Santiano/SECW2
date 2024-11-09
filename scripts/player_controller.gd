extends Node2D

# @export makes a variable visible in the inspector for editing. In this case, we can export 'TilesNode'
# and then go through the editor to point to our 'Tiles' node. This is the best way to access different nodes in
# code as it means less code changes when refactoring

@export var TilesNode : Node2D
@export var HoverTiles : TileMapLayer
@export var TextLabel : Label

#We need a more elegant solution for this, but right now I'm just storing the tiles as integers,
#with its name being the identifier and the value being its ID. It would likely make more sense to
#use an array of dictionaries so that each tile can have more properties. Unsure whether that should be stored here
#or somewhere within the Tiles node
var Grass = 0
var Building = 1
var currentTile = Grass
var activeLayer = 0
#activeLayer controls which layer (GrassLayer,BuildingLayer) the user is placing the tiles on.
#Right now I'm unsure how necessary this is going to be for what we're doing -- would the player only need
#to interact with one plane?

var _HoverTilePosition = Vector2i(0,0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	TilesNode.set("_currentLayer",activeLayer) #set the initial tile layer as soon as possible to avoid weirdness

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

#Called every 'physics' frame which, ideally, runs at x frames per second regardless of the game's actual framerate.
#Most actual processing should either go on in here, or in _process with manipulation of delta time to maintain consistent speed.
func _physics_process(delta: float) -> void:
	allInputs()
	hoverTiles()
	setLabel()
	
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

func mouseInput():
	#Grabs the position of the mouse cursor in terms of x and y
	var mousePosition = get_global_mouse_position()
	
	return mousePosition

func mouseInputToTileMap():
	#Takes the mouse location and returns coordinates in terms of the tilemap - very important for placing tiles,
	#showing which time the user is hovering over etc.
	var currentMousePosition = mouseInput()
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
	if currentTile > 0:
		currentTile = 0
		activeLayer = 0
	else:
		currentTile += 1
		activeLayer = 1

func hoverTiles():
	#HoverTiles.set_cell(mouseInputToTileMap(),currentTile,Vector2i(0,0),0)
	if _HoverTilePosition != mouseInputToTileMap():
		HoverTiles.clearTile(_HoverTilePosition.x,_HoverTilePosition.y)
		_HoverTilePosition = mouseInputToTileMap()
		HoverTiles.placeTile(currentTile,_HoverTilePosition.x,_HoverTilePosition.y)
	#If the mouse position has changed since the last iteration,
	#clear the previous tile and then draw the new one.
	#This is just for the visual effect of seeing the tile before you place it-
	#not that important.   Could also make it check whether there's already a tile there -
	#that could go in the general placeTile function in the TilesLayer script
	
func setLabel():
	#Quick way of showing info on the screen. TEMPORARY. We want nice UI
	var textToDisplay = str("Selected Tile: ", currentTile,"\n")
	TextLabel.set("text",textToDisplay)
