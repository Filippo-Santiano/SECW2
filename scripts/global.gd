extends Node

var Money = 15
var Pollution = 0
var Electricity = 0
var Happiness = 1
var PollutionThreshold = 1000

var currentYear : float

var YearlyPollution: = 0
var placed_tiles: Array = []
var Income = 0
var ExternalPollution = 1

# Fix this, current doesn't update income, fixed pollution levels etc when tiles are built
#func updatePollution():
	#var total_yearly_pollution = 0
	#for i in placed_tiles:
		#total_yearly_pollution += i.yearly_pollution
	#YearlyPollution = total_yearly_pollution
	##print("Recalculated Yearly Pollution:", Global.YearlyPollution)
	#
#func updateIncome():
	#var total_yearly_income = 0
	#for i in placed_tiles:
		#total_yearly_income += i.yearly_income
	#Income = total_yearly_income
	#
#func updateElectricity():
	#var total_electricity = 0
	#for i in placed_tiles:
		#total_electricity += i.electricity
	#Electricity = total_electricity
	#
#func updateHappiness():
	#var total_happiness = 0
	#for i in placed_tiles:
		#total_happiness += i.happiness
	#Happiness = total_happiness
	
func updateExternalPollution():
	var totalExternalPollutionMultiplier = 1.08
	ExternalPollution *= totalExternalPollutionMultiplier

	
	
	#
#func addNewTile(tile,initial_pollution):
	#Pollution += initial_pollution
	#var new_tile = Tile.new() #creates an instance of the Tile class, with
	#new_tile.id = tile #id of the tile being placed.
	#new_tile.initialise_pollution()
	#new_tile.initialise_income() #then sets the pollution/income variables based on the ID
	#new_tile.initialise_electricity()
	#new_tile.initialise_happiness()
	#placed_tiles.append(new_tile) #and adds that tile to the global placed_tiles array.
	##this is used for adding pollution/income yearly

#func updateData():
	#updatePollution()
	#updateIncome()
	#updateElectricity()	
	#updateHappiness()

var tile_data = {}

func update_tile_attributes():
	for pos in tile_data.keys():
		var tile = tile_data[pos]
		var years_elapsed = currentYear - tile["placed_time"]
		for attr in tile["attributes"].keys():
			var multipler = tile["multipliers"].get(attr, 0)
			tile["attributes"][attr] *= pow(1 + tile["multipliers"][attr], years_elapsed)
		print("Updated tile at", pos, ":", tile["attributes"])  # Debug print

func updateData(x,y):
	
	#Called after a tile is placed in the tile_placer scene.
	#Grabs the attributes from the placed tile in the dictionary and adds them to the current
	#totals.
	#Haven't put in happiness or electricity as unsure exactly how the two variables should be utilised
	
	var tile = tile_data.get(Vector2(x,y))
	var attributes = tile.get("attributes")
	
	Pollution += attributes.get("yearly_pollution")
	YearlyPollution += attributes.get("yearly_pollution")
	Income += attributes.get("income")
