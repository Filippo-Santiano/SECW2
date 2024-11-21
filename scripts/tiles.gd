extends Node2D
class_name Tile

@export var TilesLayer : TileMapLayer
@export var HoverTiles : TileMapLayer
@export var PollutionLabel : Label
@export var IncomeLabel : Label
@export var MoneyLabel : Label
@export var PopupBox : Popup

const LAYERS = 1
const TILE_PLACER : PackedScene = preload("res://scenes/tile_placer.tscn")

# the _ underscore denotes a private variable. Get and set allow for the variable to be accessed by different
# nodes but we can limit their access. This is good practice for alleviating bugs
var _currentLayer = 0:
	get:
		return _currentLayer
	set(value):
		if value > 0:
			_currentLayer = value

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	updatePollution()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#print(Global.Pollution)
	pass

func editTile(mode,tile,x,y):
	#if the layer has been set within max layers
	if _currentLayer <= LAYERS:
		TilesLayer = get_node(str("Layer",_currentLayer)) #edit on that layer
	else:
		TilesLayer = $Layer1 #otherwise, default to 1.
	
	if mode == "ADD":
		placeTile(tile,x,y)
		
	elif mode =="DEL":
		sellTile(x,y)
		
	else:
		print("tried to edit tile, but mode unknown")

var id: int = 0  # Tile ID
var yearly_pollution: int = 0  # Dynamic yearly pollution
var yearly_income: int = 0 # Dynamic income

# Mapping IDs to default yearly pollution values
const Initial_Yearly_Tile_Pollution = {
	1: 15,  # Office adds pollution yearly
	2: -10    # Forest reduces yearly pollution
}

const Initial_Yearly_Income = {
	1: 20
}

# Initialize dynamic pollution value
func initialise_pollution():
	if id in Initial_Yearly_Tile_Pollution:
		yearly_pollution = Initial_Yearly_Tile_Pollution[id]
	else:
		yearly_pollution = 0  # Default if ID is not in the mapping
	#print("Initialised yearly pollution for Tile ID:", id, "->", yearly_pollution)


func initialise_income():
	if id in Initial_Yearly_Income:
		yearly_income = Initial_Yearly_Income[id]
	else:
		yearly_income = 0

func placeTile(tile,x,y):
	if TilesLayer.get_cell_tile_data(Vector2i(x,y)) == null: #if no tile is present at those coordinates on that layer
		var floorType = null
		if $Layer0.get_cell_tile_data(Vector2i(x,y)) != null: #if the tile below exists
			floorType = $Layer0.get_cell_tile_data(Vector2i(x,y)).get_custom_data("Type") #grab its type
		if floorType == "Ground":
			
			var tileToPlace = TilesLayer.tile_set.get_source(tile).get_tile_data(Vector2i(0,0),0) #Gets the custom data of the current Tile ID.
			var timeToBuild = tileToPlace.get_custom_data("timeToBuild")					#Atlas coords are just 0,0 because we have one tile per atlas.
			var cost = tileToPlace.get_custom_data("Cost")
			
			if Global.Money >= cost:
				Global.Money -= cost
				
				#Instantiates a tile placer node that either places a construction tile and waits x years, or, if timeToBuild = 0,
				#places the tile. This means we can have multiple tiles being constructed at once.
				
				var tilePlacer = TILE_PLACER.instantiate()
				tilePlacer.initialise(TilesLayer, Global.currentYear, timeToBuild)
				add_child(tilePlacer)
				tilePlacer.addNewTile(tile)
				tilePlacer.place(tile,x,y)
				#updatePollution() and updateIncome() are now called within tilePlacer, after the tile is built.
				
				
				var fixed_pollution = tileToPlace.get_custom_data("Pollution")
				Global.Pollution += fixed_pollution
				
			else:
				print("Not enough molah")
				
func sellTile(x,y):
	var currentTileData = TilesLayer.get_cell_tile_data(Vector2i(x,y))
	if currentTileData != null:
		if currentTileData.get_custom_data("canSell"):
			var moneyBack = currentTileData.get_custom_data("Cost") / 2
			var pollutionBack = currentTileData.get_custom_data("Pollution")
			print("Sold tile at: ", Vector2i(x,y)," for ",moneyBack," molah.")
			
			Global.Money += moneyBack
			Global.Pollution -= pollutionBack
			
			TilesLayer.clearTile(x,y)
			
		else:
			print("Can't sell this!")
				
func updatePollution():
	var total_yearly_pollution = 0
	for i in Global.placed_tiles:
		total_yearly_pollution += i.yearly_pollution
	Global.YearlyPollution = total_yearly_pollution
	#print("Recalculated Yearly Pollution:", Global.YearlyPollution)
	
func updateIncome():
	var total_yearly_income = 0
	for i in Global.placed_tiles:
		total_yearly_income += i.yearly_income
	Global.Income = total_yearly_income
	
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
	# Customize popup content with tile details
	print(PopupBox)
	PopupBox.get_node("Label").text = "Building at: %s \n (ID: %d)" % [tile_pos, tile_id]
	print(tile_pos)
	var world_pos = TilesLayer.map_to_local(tile_pos)
	print(world_pos)
	var offset_x = (world_pos.x + 576)*1.5
	var offset_y = (world_pos.y + 352)*1.48
	PopupBox.position = Vector2(offset_x,offset_y)
	# Show and center the popup
	PopupBox.show()
	# Shows the popup with tile information

# Custom method to get a tile ID
func get_tile_id(tile_pos: Vector2i) -> int:
	var tile_id = TilesLayer.get_cell_source_id(Vector2i(tile_pos.x, tile_pos.y))
	return tile_id if tile_id != -1 else -1 # Return the tile ID or -1 if no tile is present 
