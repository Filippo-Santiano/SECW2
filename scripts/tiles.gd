extends Node2D
class_name Tile

@export var TilesLayer : TileMapLayer
@export var HoverTiles : TileMapLayer
@export var PollutionLabel : Label
@export var IncomeLabel : Label
@export var MoneyLabel : Label
@export var ToolTipBox : Control
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
		"positiveHappiness": 0,
		"negativeHappiness": 8
	},
	2: {  # Forest
		"name" : "Forest",
		"yearly_pollution": -30,
		"income": 0,
		"electricityRequired": 0,
		"electricityGenerated": 0,
		"positiveHappiness": 9,
		"negativeHappiness": 0
	},
	28: {  # Orange Forest
		"name" : "Orange Forest",
		"yearly_pollution": -20,
		"income": 5,
		"electricityRequired": 0,
		"electricityGenerated": 0,
		"positiveHappiness": 7,
		"negativeHappiness": 0
	},
	29: {  # Rubber Forest
		"name" : "Rubber Forest",
		"yearly_pollution": -25,
		"income": 8,
		"electricityRequired": 0,
		"electricityGenerated": 0,
		"positiveHappiness": 7,
		"negativeHappiness": 0
	},
	30: {  # Palm Forest
		"name" : "Palm Forest",
		"yearly_pollution": -15,
		"income": 10,
		"electricityRequired": 0,
		"electricityGenerated": 0,
		"positiveHappiness": 8,
		"negativeHappiness": 4
	},
	31: {  # Cocoa Forest
		"name" : "Cocoa Forest",
		"yearly_pollution": -22,
		"income": 12,
		"electricityRequired": 0,
		"electricityGenerated": 0,
		"positiveHappiness": 7,
		"negativeHappiness": 0
	},
	32: {  # Coal PP
		"name" : "Coal Power Plant",	
		"yearly_pollution": 60,
		"income": -50,
		"electricityRequired": 5,
		"electricityGenerated": 10,
		"positiveHappiness": 0,
		"negativeHappiness": 100
	},
	33: {  # Nuclear PP
		"name" : "Nuclear Power Plant",
		"yearly_pollution": 20,
		"income": -10,
		"electricityRequired": 5,
		"electricityGenerated": 15,
		"positiveHappiness": 0,
		"negativeHappiness": 75
	},
	34: {  # Wind Farm
		"name" : "Wind Farm",
		"yearly_pollution": 0,
		"income": -5,
		"electricityRequired": 1,
		"electricityGenerated": 7,
		"positiveHappiness": 10,
		"negativeHappiness": 2
	},
	35: {  # Leisure Centre
		"name" : "Leisure Centre",
		"yearly_pollution": 3,
		"income": 10,
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
		"positiveHappiness": 100,
		"negativeHappiness": 5
	},
	37: {  # Dairy Farm
		"name" : "Dairy Farm",
		"yearly_pollution": 2,
		"income": 40,
		"electricityRequired": 0.2,
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
		"yearly_pollution": 8,
		"income": 60,
		"electricityRequired": 0.4,
		"electricityGenerated": 0,
		"positiveHappiness": 1,
		"negativeHappiness": 1
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
		"yearly_pollution": 0.01,
		"income": 0,
		"electricityRequired": 0,
		"electricityGenerated": 0,
		"positiveHappiness": 0.01,
		"negativeHappiness": 0
		},
	28: { #Orange Forest
		"yearly_pollution": 0.01,
		"income": 0,
		"electricityRequired": 0,
		"electricityGenerated": 0,
		"positiveHappiness": 0.01,
		"negativeHappiness": 0
		},
	29: { #Rubber Forest
		"yearly_pollution": 0.01,
		"income": 0,
		"electricityRequired": 0,
		"electricityGenerated": 0,
		"positiveHappiness": 0.01,
		"negativeHappiness": 0
		},
	30: { #Palm Forest
		"yearly_pollution": 0.01,
		"income": 0,
		"electricityRequired": 0,
		"electricityGenerated": 0,
		"positiveHappiness": 0.01,
		"negativeHappiness": 0
		},
	31: { #Cocoa Forest
		"yearly_pollution": 0.01,
		"income": 0,
		"electricityRequired": 0,
		"electricityGenerated": 0,
		"positiveHappiness": 0.01,
		"negativeHappiness": 0
		},
	32: { #Coal PP
		"yearly_pollution": 0.06,
		"income": 0.04,
		"electricityRequired": 0,
		"electricityGenerated": -0.04,
		"positiveHappiness": 0,
		"negativeHappiness": 0.04
		},
	33: { #Nuclear PP
		"yearly_pollution": 0.01,
		"income": 0.04,
		"electricityRequired": 0,
		"electricityGenerated": -0.01,
		"positiveHappiness": 0.03,
		"negativeHappiness": 0.06
		},
	34: { #Wind Farm
		"yearly_pollution": 0.02,
		"income": 0.06,
		"electricityRequired": 0,
		"electricityGenerated": -0.02,
		"positiveHappiness": 0,
		"negativeHappiness": 0.01
		},
	35: { #Leisure Centre
		"yearly_pollution": 0.02,
		"income": -0.02,
		"electricityRequired": 0.02,
		"electricityGenerated": 0,
		"positiveHappiness": 0,
		"negativeHappiness": 0.01
		},
	36: { #Stadium
		"yearly_pollution": 0.02,
		"income": 0,
		"electricityRequired": 0.03,
		"electricityGenerated": 0,
		"positiveHappiness": -0.05,
		"negativeHappiness": 0.01
		},
	37: { #Dairy Farm
		"yearly_pollution": 0.02,
		"income": -0.04,
		"electricityRequired": 0.04,
		"electricityGenerated": 0,
		"positiveHappiness": 0.04,
		"negativeHappiness": 0
		},
	38: { #Park
		"yearly_pollution": 0.02,
		"income": 0,
		"electricityRequired": 0,
		"electricityGenerated": 0,
		"positiveHappiness": 0.01,
		"negativeHappiness": 0
		},
	39: { #Wheat Farm
		"yearly_pollution": 0.04,
		"income": -0.06,
		"electricityRequired": 0.04,
		"electricityGenerated": 0,
		"positiveHappiness": 0,
		"negativeHappiness": 0.04
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
			var initialPollution = tileToPlace.get_custom_data("Pollution")
			var cost = tileToPlace.get_custom_data("Cost")
			
			if Global.chargeMoney(cost):
				
				Global.Pollution += initialPollution
				
				#Adds the placed tile to the global placed tiles array + sets initial pollution
				#var fixed_pollution = tileToPlace.get_custom_data("Pollution")
				#Global.addNewTile(tile, fixed_pollution)
				
				#setInitialAttributes(tile,x,y)
				
				#Instantiates a tile placer node that either places a construction tile and waits x years, or, if timeToBuild = 0,
				#places the tile. This means we can have multiple tiles being constructed at once.
				var tilePlacer = TILE_PLACER.instantiate()
				tilePlacer.initialise(TilesLayer, Global.currentYear, timeToBuild)
				add_child(tilePlacer)
				tilePlacer.place(tile,x,y)
				
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
	var viewportMousePos = get_viewport().get_mouse_position()
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if not Global.menuOpen:
			var world_pos = get_global_mouse_position()
			var tile_pos = TilesLayer.local_to_map(world_pos)
			# Retrieve tile ID and information
			var tile_id = get_tile_id(tile_pos)
			if tile_id != -1: # Check if a tile exists at the position
				show_popup(tile_pos, tile_id)
			else:
				ToolTipBox.hideToolTip()

# Generates a fun fact depending on the building type
func generate_fun_fact(asset_name):
	#Power Plants
	if asset_name == "Coal Power Plant":
		var random_string = [
			"Coal power plants emit on average 100x more carbon than onshore wind farms per kWh.",
			"In 2023, coal was the greatest contributor to carbon emissions, accounting for 15.7 gigatonnes (Gt) of the 37.7 Gt of CO₂ released by the energy sector.", 
			"The UK's last coal power plant was shut down at the end of September 2024."
			][randi() % 3]
		return random_string
			
	elif asset_name == "Nuclear Power Plant":
		var random_string = [
			"Per kWh of energy produced, nuclear power plants emit approximately 30x less carbon than coal.",
			"In 2023, nuclear generation supplied more than 2600 TWh globally. That's 9% of the world's electricity!", 
			"The UK generates about 15% of its electricity from about 6.5 GW of nuclear capacity.",
			"'Sizewell B' is the largest nuclear reactor in the UK and has an operating capacity of 1198 MW!"
			][randi() % 4]
		return random_string
		
	elif asset_name == "Wind Farm":
		var random_string = [
			"UK wind energy reduces CO2 emissions by 35.8 million tonnes annually.",
			"UK wind energy has an installed capacity of 30,000 MW.",
			"On average, wind farms repay their energy investment in less than a year!",
			"The London Array Wind Farm has 175 turbines, generating 630 MW of power and reducing CO₂ emissions by 900,000 per tonnes per year."
			][randi() % 4]
		return random_string
			
	#Forests
	elif asset_name == "Forest":
		var random_string = "The global forest sink is equivalent to half of fossil fuel emissions (7.8 ± 0.4 PgC per year)."
		return random_string
	elif asset_name == "Orange Forest":
		var random_string = "An orange tree plantation can remove approximately 3 tonnes of Carbon per Hectare per year."
		return random_string
	elif asset_name == "Rubber Forest":
		var random_string = "A rubber tree plantation can remove approximately 5 tonnes of Carbon per Hectare per year."
		return random_string
	elif asset_name == "Palm Forest":
		var random_string = "A palm tree plantation can remove approximately 3 tonnes of Carbon per Hectare per year."
		return random_string
	elif asset_name == "Cocoa Forest":
		var random_string = "A cocoa tree plantation can remove approximately 3 tonnes of Carbon per Hectare per year."
		return random_string
	
	#Agriculture
	elif asset_name == "Dairy Farm":
		var random_string = ["A fully developed cow can emit up to 500 litres of methane each day!",
							"Cows are estimated to accounts for 3.7 % of all all greenhouse gas emissions."
							][randi() % 2]
		return random_string
	elif asset_name == "Wheat Farm":
		var random_string = "For each kg of wheat grain produced, a net 0.03–0.38 kg CO₂ is sequestered into the soil."
		return random_string
	
	#Leisure
	elif asset_name == "Stadium":
		var random_string = [
			"Wembley stadium has an annual electricity consumption of 22.19 GWh!",
			"A 55,000 spectator stadium can reach energy uses of 10,000 MWh/year, which equates to 3600 tonnes of CO₂/year",
			"The Eco Park in Gloucestershire aims to become the world’s first timber stadium, generating 80% of its electricity on-site.", 
			][randi() % 3]
		return random_string
	
	elif asset_name == "Park":
		var random_string = [
			"Under Italian urban planning law, every city in Italy is required to have at least 9m² of park or public area per person.",
			"The World Health Organisation recommends that everyone lives within 300 metres of a green space.", 
			][randi() % 2]
		return random_string
		
	elif asset_name == "Leisure Centre":
		var random_string = "Heating a leisure centre swimming pool can use up to 1600 kWh/m². This can be reduced by up to 90% using passive solar systems." 
		return random_string
		
	#Office
	elif asset_name == "Office":
		var random_string = "In the UK, offices require 27.6GWh per year and are responsible for 68% of total non-domestic electricity use."
		return random_string
	
	else:
		return null
	
func update_box(tile,type):
	print(type)
	if tile and type != "Landscape" and type != "Construction" and type != "Town Hall":
		var attributes = tile.get("attributes") #grab attributes from dictionary
		#ToolTipBox.set_text(str("Building at: %s \n (ID: %d)" % [tile_pos, tile_id]))
		
		var Name = attributes.get("name")
		var yearlyPollution : int = attributes.get("yearly_pollution")
		var yearlyIncome : int = attributes.get("income")
		var electricityRequired : float = attributes.get("electricityRequired")
		var electricityGenerated : float = attributes.get("electricityGenerated")
		var netHappiness : int = attributes.get("positiveHappiness") - attributes.get("negativeHappiness")
		
		ToolTipBox.set_text(Name,"Name")
		ToolTipBox.set_text(str("Environment: ",yearlyPollution),"Environment")
		ToolTipBox.set_text(str("Money: ","£",yearlyIncome),"Money")
		ToolTipBox.set_text(str("Usage: -",snapped(electricityRequired,0.01)),"ElectricityUse")
		ToolTipBox.set_text(str("Generating: ","+",snapped(electricityGenerated,0.01)),"ElectricityGen")
		ToolTipBox.set_text(str("Happiness: ",netHappiness),"Happiness")
		# Insert fun fact depending on building type.
		var funFact = generate_fun_fact(Name)
		ToolTipBox.set_text(funFact,"FunFact")
	elif type == "Landscape" or type == "Construction" or type == "Town Hall":
		ToolTipBox.set_text(type,"Name")
		if type == "Town Hall":
			ToolTipBox.set_text("Generating: 1","ElectricityUse")
			ToolTipBox.set_text("","FunFact")
			
	else:
		ToolTipBox.set_text("Cannot identify tile","Name")
	#print("")
	ToolTipBox.showToolTip()
	# Show and center the popup
	# Shows the popup with tile information
	
func Reset_Repair_Label(tile):
	if tile:
		ToolTipBox.reset_repair()
	ToolTipBox.changeCost("")
	button_on_off = 0
	#print("")

# Shows the popup with tile information
func show_popup(tile_pos: Vector2i, tile_id: int):
	ToolTipBox.resetAll()
	var tile_data = TilesLayer.get_cell_tile_data(tile_pos)
	var type = tile_data.get_custom_data("Type")
	print(type)
	Global.Repair_Tile_Pos = tile_pos
	# Customize popup content with tile details
	var tile = Global.tile_data.get(Vector2(tile_pos))
	ToolTipBox.position = get_global_mouse_position()
	update_box(tile,type)
	Reset_Repair_Label(tile)

var IniYPol = 0
var IniInc = 0
var IniElecReq = 0
var IniElecGen = 0
var IniPosHapp = 0
var IniNegHapp = 0
var RepairCost = 0

func get_repair_data():
	var tile = Global.tile_data.get(Vector2(Global.Repair_Tile_Pos))
	if tile:
		var tile_data = TilesLayer.get_cell_tile_data(Global.Repair_Tile_Pos)
		var cost = tile_data.get_custom_data("Cost")
		RepairCost = cost / 2
		
		var Asset_ID = tile.get("Asset_ID")
		var initial_attributes = Initial_Tile_Attributes.get(Asset_ID,{
		"yearly_pollution": 0,
		"income": 0,
		"electricityRequired": 0,
		"electricityGenerated": 0,
		"positiveHappiness": 0,
		"negativeHappiness": 0
		})

		var attributes = tile.get("attributes") #grab attributes from dictionary
		var Name = attributes.get("name")
		var yearlyPollution : int = attributes.get("yearly_pollution")
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
		
		update_box(tile,"")
		ToolTipBox.set_repair(str(IniYPol - yearlyPollution),"Environment")
		ToolTipBox.set_repair(str(IniInc - yearlyIncome),"Money")
		ToolTipBox.set_repair(str(IniElecReq - electricityRequired),"ElectricityUse")
		ToolTipBox.set_repair(str(IniElecGen - electricityGenerated),"ElectricityGen")
		ToolTipBox.set_repair(str((IniPosHapp - PosHappiness) - (IniNegHapp - NegHappiness)),"Happiness")
 

func repair_tile():
	var tile = Global.tile_data.get(Vector2(Global.Repair_Tile_Pos))
	if tile:
		tile["attributes"]["yearly_pollution"] = IniYPol
		tile["attributes"]["income"] = IniInc
		tile["attributes"]["electricityRequired"] = IniElecReq
		tile["attributes"]["electricityGenerated"] = IniElecGen
		tile["attributes"]["positiveHappiness"] = IniPosHapp
		tile["attributes"]["negativeHappiness"] = IniNegHapp
		update_box(tile,"")
		Reset_Repair_Label(tile)

	# Update the values
	# Refresh all the global variables




# Custom method to get a tile ID
func get_tile_id(tile_pos: Vector2i) -> int:
	var tile_id = TilesLayer.get_cell_source_id(Vector2i(tile_pos.x, tile_pos.y))
	return tile_id if tile_id != -1 else -1 # Return the tile ID or -1 if no tile is present 

var button_on_off = 0

func _on_tool_tip_box_repair_button_pressed() -> void:
	if button_on_off == 0:
		print("Button Pressed, state: ", button_on_off)
		get_repair_data()
		ToolTipBox.changeButtonText(true)
		ToolTipBox.changeCost(str("Cost: ", RepairCost))
		button_on_off = 1
	else:
		if Global.chargeMoney(RepairCost):
			repair_tile()
			print("Button Pressed, state: ", button_on_off)
			ToolTipBox.changeButtonText(false)
			ToolTipBox.changeCost("")
			button_on_off = 0
		else:
			print("Not enough Molah")
			print("Button Pressed, state: ", button_on_off)
			ToolTipBox.changeButtonText(false)
			ToolTipBox.changeCost("")
			button_on_off = 0
