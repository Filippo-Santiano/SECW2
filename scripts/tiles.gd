extends Node2D

class_name Tile

@export var TilesLayer : TileMapLayer
@export var HoverTiles : TileMapLayer
@export var PollutionLabel : Label

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



var id: int = 0  # Tile ID
var yearly_pollution: int = 0  # Dynamic yearly pollution

# Mapping IDs to default yearly pollution values
const Initial_Yearly_Tile_Pollution = {
	1: 15,  # Office adds pollution yearly
	2: -10    # Forest reduces yearly pollution
}

# Initialize dynamic pollution value
func initialise_pollution():
	if id in Initial_Yearly_Tile_Pollution:
		yearly_pollution = Initial_Yearly_Tile_Pollution[id]
	else:
		yearly_pollution = 0  # Default if ID is not in the mapping
	#print("Initialised yearly pollution for Tile ID:", id, "->", yearly_pollution)


func placeTile(tile,x,y):
	if TilesLayer.get_cell_tile_data(Vector2i(x,y)) == null: #if no tile is present at those coordinates on that layer
		if $Layer0.get_cell_tile_data(Vector2i(x,y)).get_custom_data("Type") == "Ground":
			
			var tileToPlace = TilesLayer.tile_set.get_source(tile).get_tile_data(Vector2i(0,0),0) #Gets the custom data of the current Tile ID.
			var timeToBuild = tileToPlace.get_custom_data("timeToBuild")					#Atlas coords are just 0,0 because we have one tile per atlas.
			
			var new_tile = Tile.new()
			new_tile.id = tile
			new_tile.initialise_pollution()
			
			Global.placed_tiles.append(new_tile)
			
			
			TilesLayer.placeTile(tile,x,y) #place tile.
			
			
			
			var fixed_pollution = tileToPlace.get_custom_data("Pollution")
			Global.Pollution += fixed_pollution
			#print("Added fixed pollution:", fixed_pollution, "-> Total Pollution:", Global.Pollution)
			#updatePollution()
			
			updatePollution()
			
			#Global.YearlyPollution +=new_tile.yearly_pollution
			#print("Added yearly pollution:", new_tile.yearly_pollution, "_> Total Yearly Pollution:", Global.YearlyPollution)
		#this is currently living in this script so that the generic 'placeTile' function within
		#each TileMapLayer's script can still be used for the hovering tiles, plus any other instance where we might
		#need to forcibly replace a tile.
	

#Grabs every tile on a layer and sums the total pollution. Again, how necessary the layers are is worth thinking
#about. This could be fine as it is with a single layer, or a parent script that contains global variables such
#as this could sum each layer to calculate the total.
#func updatePollution():
	#
	#var total_fixed_pollution = 0
	#var total_yearly_pollution = 0
	#
	#for x in LAYERS+1: #Updates pollution for ALL layers by checking all current tiles
		#var currentLayer = get_node("Layer"+str(x))
		#var TileList = currentLayer.get_used_cells()
		#for tile_pos in TileList:
			#var NewTileData = currentLayer.get_cell_tile_data(tile_pos)
			#if NewTileData:
				#total_fixed_pollution += NewTileData.get_custom_data("Pollution")
				#for tile in Global.placed_tiles:
					#if tile.id == currentLayer.get_cell_source_id(tile_pos):
						#total_yearly_pollution += tile.yearly_pollution
	#
	#Global.Pollution = total_fixed_pollution
	#Global.YearlyPollution = total_yearly_pollution
				#
	#print("Global Pollution:", Global.Pollution, "Yearly Pollution:", Global.YearlyPollution)
	#var pollution_label = get_node("YearsTimer/PollutionLabel")
	#
	#if pollution_label:
		#pollution_label.update_pollution_label()
	#else:
		#print("pollution_label not found in the scene tree!")
		
func updatePollution():
	var total_yearly_pollution = 0
	for i in Global.placed_tiles:
		total_yearly_pollution += i.yearly_pollution
	Global.YearlyPollution = total_yearly_pollution
	print(Global.Pollution)
	PollutionLabel.update_pollution_label()
	#print("Recalculated Yearly Pollution:", Global.YearlyPollution)

	
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
	print(tile_pos)
	var world_pos = TilesLayer.map_to_local(tile_pos)
	print(world_pos)
	var offset_x = (world_pos.x + 576)*1.5
	var offset_y = (world_pos.y + 352)*1.48
	popup.position = Vector2(offset_x,offset_y)
	# Show and center the popup
	popup.show()
	# Shows the popup with tile information

# Custom method to get a tile ID
func get_tile_id(tile_pos: Vector2i) -> int:
	var tile_id = TilesLayer.get_cell_source_id(Vector2i(tile_pos.x, tile_pos.y))
	return tile_id if tile_id != -1 else -1 # Return the tile ID or -1 if no tile is present 
