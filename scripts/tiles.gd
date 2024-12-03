extends Node2D
class_name Tile

@export var TilesLayer : TileMapLayer
@export var HoverTiles : TileMapLayer
@export var PollutionLabel : Label
@export var IncomeLabel : Label
@export var MoneyLabel : Label
@export var ToolTipBox : Panel
@export var Camera : Camera2D
@export var PlayerController: Node

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
	pass

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
var electricity: int = 0 # Non dynamic electricity
var happiness: int = 50 # comme ci comme ca


const Initial_Yearly_Tile_Pollution = {
	1: 15,  # Office adds pollution yearly
	2: -10    # Forest reduces yearly pollution
}

const Initial_Yearly_Income = {
	1: 20
}

const Initial_Electricity = {
	1: -10
}

const Initial_Happiness = {
	1: 5,
	2: 10 # Tree makes me happy
	}
	
## Mapping IDs to default yearly pollution values
#const Initial_Yearly_Tile_Pollution = {
	#1: 100,  # Office adds pollution yearly
	#2: -100    # Forest reduces yearly pollution
#}
#const Initial_Yearly_Income = {
	#1: 15
#}
#
#const Initial_Electricity = {
	#1: -10
#}
#
#const Initial_Happiness = {
	#1: -1,
	#2: 10, # Tree makes me happy
	##28: 10,
	##29: 10,
	##30: 10,
	##31: 10,
	##32: -15,
	##33: -15,
	##34: -5,
	##35: 5,
	##36: 7,
	##37: 2,
	##38: 10,
	##39: 2 
#}

# Sets the initial values for each of the different buildings based on ID value
const Initial_Tile_Attributes = {
	1: {  # Office
		"name" : "Office",
		"yearly_pollution": 50,
		"income": 350,
		"electricityRequired": 2.5,
		"electricityGenerated": 0,
		"positiveHappiness": 8,
		"negativeHappiness": 8
	},
	2: {  # Forest
		"name" : "Forest",
		"yearly_pollution": -30,
		"income": 0,
		"electricityRequired": 0,
		"electricityGenerated": 0,
		"positiveHappiness": 18,
		"negativeHappiness": 0
	},
	28: {  # Orange Forest
		"name" : "Orange Forest",
		"yearly_pollution": -20,
		"income": 5,
		"electricityRequired": 0,
		"electricityGenerated": 0,
		"positiveHappiness": 14,
		"negativeHappiness": 0
	},
	29: {  # Rubber Forest
		"name" : "Rubber Forest",
		"yearly_pollution": -25,
		"income": 8,
		"electricityRequired": 0,
		"electricityGenerated": 0,
		"positiveHappiness": 14,
		"negativeHappiness": 0
	},
	30: {  # Palm Forest
		"name" : "Palm Forest",
		"yearly_pollution": -15,
		"income": 10,
		"electricityRequired": 0,
		"electricityGenerated": 0,
		"positiveHappiness": 11,
		"negativeHappiness": 2
	},
	31: {  # Cocoa Forest
		"name" : "Cocoa Forest",
		"yearly_pollution": -22,
		"income": 12,
		"electricityRequired": 0,
		"electricityGenerated": 0,
		"positiveHappiness": 14,
		"negativeHappiness": 0
	},
	32: {  # Coal PP
		"name" : "Coal Power Plant",	
		"yearly_pollution": 60,
		"income": 0,
		"electricityRequired": 5,
		"electricityGenerated": 10,
		"positiveHappiness": 0,
		"negativeHappiness": 20
	},
	33: {  # Nuclear PP
		"name" : "Nuclear Power Plant",
		"yearly_pollution": 20,
		"income": 0,
		"electricityRequired": 5,
		"electricityGenerated": 15,
		"positiveHappiness": 0,
		"negativeHappiness": 10
	},
	34: {  # Wind Farm
		"name" : "Wind Farm",
		"yearly_pollution": 0,
		"income": 0,
		"electricityRequired": 1,
		"electricityGenerated": 7,
		"positiveHappiness": 10,
		"negativeHappiness": 2
	},
	35: {  # Leisure Centre
		"name" : "Leisure Centre",
		"yearly_pollution": 3,
		"income": 0,
		"electricityRequired": 8,
		"electricityGenerated": 0,
		"positiveHappiness": 20,
		"negativeHappiness": 5
	},
	36: {  # Stadium
		"name" : "Stadium",
		"yearly_pollution": 5,
		"income": 50,
		"electricityRequired": 22,
		"electricityGenerated": 0,
		"positiveHappiness": 15,
		"negativeHappiness": 5
	},
	37: {  # Dairy Farm
		"name" : "Dairy Farm",
		"yearly_pollution": 2,
		"income": 40,
		"electricityRequired": 0,
		"electricityGenerated": 0,
		"positiveHappiness": 5,
		"negativeHappiness": 0
	},
	38: {  # Park
		"name" : "Park",
		"yearly_pollution": -5,
		"income": 0,
		"electricityRequired": 0,
		"electricityGenerated": 0,
		"positiveHappiness": 10,
		"negativeHappiness": 0
	},
	39: {  # Wheat Farm
		"name" : "Wheat Farm",
		"yearly_pollution": 2,
		"income": 70,
		"electricityRequired": 0,
		"electricityGenerated": 0,
		"positiveHappiness": 3,
		"negativeHappiness": 0
	}
}

# Sets the multiplier values for each of the different buildings based on ID value
# These values get added to 1, so 0.03 is 1.03 times the previous year
const Tile_Multipliers = {
		1: { #Office
		"yearly_pollution": 0.03, #+3% pollution
		"income": -0.05,
		"electricityRequired": 0.05,
		"electricityGenerated": 0,
		"positiveHappiness": 0,
		"negativeHappiness": 0.05
		},
	2: { #Forest
		"yearly_pollution": 0.02,
		"income": 0,
		"electricityRequired": 0,
		"electricityGenerated": 0,
		"positiveHappiness": 0.04,
		"negativeHappiness": 0
		},
	28: { #Orange Forest
		"yearly_pollution": 0.02,
		"income": 0,
		"electricityRequired": 0,
		"electricityGenerated": 0,
		"positiveHappiness": 0.04,
		"negativeHappiness": 0
		},
	29: { #Rubber Forest
		"yearly_pollution": 0.02,
		"income": 0,
		"electricityRequired": 0,
		"electricityGenerated": 0,
		"positiveHappiness": 0.04,
		"negativeHappiness": 0
		},
	30: { #Palm Forest
		"yearly_pollution": 0.02,
		"income": 0,
		"electricityRequired": 0,
		"electricityGenerated": 0,
		"positiveHappiness": 0.04,
		"negativeHappiness": 0
		},
	31: { #Cocoa Forest
		"yearly_pollution": 0.02,
		"income": 0,
		"electricityRequired": 0,
		"electricityGenerated": 0,
		"positiveHappiness": 0.04,
		"negativeHappiness": 0
		},
	32: { #Coal PP
		"yearly_pollution": 0.02,
		"income": 0,
		"electricityRequired": 0,
		"electricityGenerated": 0,
		"positiveHappiness": 0.04,
		"negativeHappiness": 0
		},
	33: { #Nuclear PP
		"yearly_pollution": 0.02,
		"income": 0,
		"electricityRequired": 0,
		"electricityGenerated": 0,
		"positiveHappiness": 0.04,
		"negativeHappiness": 0
		},
	34: { #Wind Farm
		"yearly_pollution": 0.02,
		"income": 0,
		"electricityRequired": 0,
		"electricityGenerated": 0,
		"positiveHappiness": 0.04,
		"negativeHappiness": 0
		},
	35: { #Leisure Centre
		"yearly_pollution": 0.02,
		"income": 0,
		"electricityRequired": 0,
		"electricityGenerated": 0,
		"positiveHappiness": 0.04,
		"negativeHappiness": 0
		},
	36: { #Stadium
		"yearly_pollution": 0.02,
		"income": 0,
		"electricityRequired": 0,
		"electricityGenerated": 0,
		"positiveHappiness": 0.04,
		"negativeHappiness": 0
		},
	37: { #Dairy Farm
		"yearly_pollution": 0.02,
		"income": 0,
		"electricityRequired": 0,
		"electricityGenerated": 0,
		"positiveHappiness": 0.04,
		"negativeHappiness": 0
		},
	38: { #Park
		"yearly_pollution": 0.02,
		"income": 0,
		"electricityRequired": 0,
		"electricityGenerated": 0,
		"positiveHappiness": 0.04,
		"negativeHappiness": 0
		},
	39: { #Wheat Farm
		"yearly_pollution": 0.02,
		"income": 0,
		"electricityRequired": 0,
		"electricityGenerated": 0,
		"positiveHappiness": 0.04,
		"negativeHappiness": 0
		}
}

# This assigns these intial attributes to each new tile placed
func setInitialAttributes(tile,x,y):
	if Global.tile_data == null:
		Global.tile_data = {}
				
	# Initialises the attributes
	var initial_attributes = Initial_Tile_Attributes.get(tile,{
		"yearly_pollution": 0,
		"income": 0,
		"electricityRequired": 0,
		"electricityGenerated": 0,
		"positiveHappiness": 0,
		"negativeHappiness": 0
	})
	
	# Initiailises the multiplers
	var multipliers = Tile_Multipliers.get(tile,{
		"yearly_pollution": 0,
		"income": 0,
		"electricityRequired": 0,
		"electricityGenerated": 0,
		"positiveHappiness": 0,
		"negativeHappiness": 0
	})
	
	# Assigns the attributes and multipliers to a each unique coordinate
	Global.tile_data[Vector2(x,y)] = {
		"attributes": initial_attributes.duplicate(true),
		"multipliers": multipliers.duplicate(true),
		"placed_time": Global.currentYear,
		"Asset_ID": tile
	}

##############################################
# When we sell, we need to remove it from the tile_data list
##############################################


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
				
				#Adds the placed tile to the global placed tiles array + sets initial pollution
				#var fixed_pollution = tileToPlace.get_custom_data("Pollution")
				#Global.addNewTile(tile, fixed_pollution)
				
				setInitialAttributes(tile,x,y)
				
				#Instantiates a tile placer node that either places a construction tile and waits x years, or, if timeToBuild = 0,
				#places the tile. This means we can have multiple tiles being constructed at once.
				var tilePlacer = TILE_PLACER.instantiate()
				tilePlacer.initialise(TilesLayer, Global.currentYear, timeToBuild)
				add_child(tilePlacer)
				tilePlacer.place(tile,x,y)
				
				
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

## Handles input for clicking tiles and displaying popup info
func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed and not Global.mouseBlocker:
		var world_pos = get_global_mouse_position()
		var tile_pos = TilesLayer.local_to_map(world_pos)
		# Retrieve tile ID and information
		var tile_id = get_tile_id(tile_pos)
		Global.Repair_Tile_Pos = tile_pos
		if tile_id != -1: # Check if a tile exists at the position
			show_popup(tile_pos, tile_id)
		else:
			ToolTipBox.hideToolTip()

# Shows the popup with tile information
func show_popup(tile_pos: Vector2i, tile_id: int):
	# Customize popup content with tile details
	var tile = Global.tile_data.get(Vector2(tile_pos))
	if tile:
		var attributes = tile.get("attributes") #grab attributes from dictionary
		#ToolTipBox.set_text(str("Building at: %s \n (ID: %d)" % [tile_pos, tile_id]))
		
		var Name = attributes.get("name")
		var yearlyPollution : int = attributes.get("yearly_pollution")
		var yearlyIncome : int = attributes.get("income")
		var electricityRequired : int = attributes.get("electricityRequired")
		var electricityGenerated : int = attributes.get("electricityGenerated")
		var netHappiness : int = attributes.get("positiveHappiness") - attributes.get("negativeHappiness")
		
		ToolTipBox.set_text(Name,"Name")
		ToolTipBox.set_text(str("Environment: ",yearlyPollution),"Environment")
		ToolTipBox.set_text(str("Money: ","£",yearlyIncome),"Money")
		ToolTipBox.set_text(str("Usage: -",electricityRequired," ¦ Generating: ","+",electricityGenerated),"Electricity")
		ToolTipBox.set_text(str("Happiness: ",netHappiness),"Happiness")
		get_repair_data()
		print("____________Trying to get repair data____________",get_repair_data())
		print("Repairing tile: ")
		repair_tile()
	else:
		ToolTipBox.set_text("Cannot identify tile","Name")
	#print("")
	ToolTipBox.position = get_global_mouse_position()
	ToolTipBox.showToolTip()
	# Show and center the popup
	# Shows the popup with tile information

var IniYPol = 0
var IniInc = 0
var IniElecReq = 0
var IniElecGen = 0
var IniPosHapp = 0
var IniNegHapp = 0

func get_repair_data():
	var tile = Global.tile_data.get(Vector2(Global.Repair_Tile_Pos))
	var Asset_ID = tile.get("Asset_ID")
	var initial_attributes = Initial_Tile_Attributes.get(Asset_ID,{
	"yearly_pollution": 0,
	"income": 0,
	"electricityRequired": 0,
	"electricityGenerated": 0,
	"positiveHappiness": 0,
	"negativeHappiness": 0
	})
	print("Intial Yearly Pollution", initial_attributes.get("yearly_pollution"))
	
	var attributes = tile.get("attributes") #grab attributes from dictionary
	var Name = attributes.get("name")
	var yearlyPollution : int = attributes.get("yearly_pollution")
	print("Yearly Pollution now: ", yearlyPollution)
	var yearlyIncome : int = attributes.get("income")
	var electricityRequired : int = attributes.get("electricityRequired")
	var electricityGenerated : int = attributes.get("electricityGenerated")
	var PosHappiness : int = attributes.get("positiveHappiness")
	var NegHappiness : int = attributes.get("negativeHappiness")
	
	IniYPol = initial_attributes.get("yearly_pollution")
	IniInc = initial_attributes.get("income")
	IniElecReq = initial_attributes.get("electricityRequired")
	IniElecGen = initial_attributes.get("electricityGenerated")
	IniPosHapp = initial_attributes.get("positiveHappiness")
	IniNegHapp = initial_attributes.get("negativeHappiness")
	
	Global.YPolDiff = IniYPol - yearlyPollution
	Global.YIncDiff = IniInc - yearlyIncome
	Global.ElecReqDiff = IniElecReq - electricityRequired
	Global.ElecGenDiff = IniElecGen - electricityGenerated
	Global.PosHappDiff = IniPosHapp - PosHappiness
	Global.NegHappDiff = IniNegHapp - NegHappiness
 

func repair_tile():
	var tile = Global.tile_data.get(Vector2(Global.Repair_Tile_Pos))
	tile["attributes"]["yearly_pollution"] = IniYPol
	tile["attributes"]["income"] = IniInc
	tile["attributes"]["electricityRequired"] = IniElecReq
	tile["attributes"]["electricityGenerated"] = IniElecGen
	tile["attributes"]["positiveHappiness"] = IniPosHapp
	tile["attributes"]["negativeHappiness"] = IniNegHapp
	

	# Update the values
	# Refresh all the global variables

# Custom method to get a tile ID
func get_tile_id(tile_pos: Vector2i) -> int:
	var tile_id = TilesLayer.get_cell_source_id(Vector2i(tile_pos.x, tile_pos.y))
	return tile_id if tile_id != -1 else -1 # Return the tile ID or -1 if no tile is present 
