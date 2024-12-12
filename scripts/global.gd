extends Node

const AIR_FILTER_REPAIR_COST = 1000
const AIR_FILTER_REPAIR_MULTIPLIER = 0.9

var mouseBlocker = false #True when the mouse hovers over the build button/menu

var Money = 75
var Pollution = 0

# Progress bars needs access to these so I've made them global
var ElectricityGenerated = 0
var ElectricityRequired = 0

var Electricity = 0
var Happiness = 1
var PollutionThreshold = 1000

var currentYear : float

var YearlyPollution: = 0
var placed_tiles: Array = []
var Income = 0
var ExternalPollution = 50
# Maximum income shows income if all buildings are repaired
var MaximumIncome = 0
var PreviousIncome = 1
var IncomeChange = 0

var Years_Over = 0

var Repair_Tile_Pos: Vector2

var moneyAnimation = preload("res://scenes/not_enough_money.tscn")



# This calculates the updated external pollution (multiplies by 1.08)
func updateExternalPollution():
	var totalExternalPollutionMultiplier = 1.08
	ExternalPollution *= totalExternalPollutionMultiplier


var tile_data = {}

# This iterates through the tiles within tile_data
# for each tile, it applies the multiplier and updates the relevant attribute value
func update_tile_attributes():
	for pos in tile_data.keys():
		var tile = tile_data[pos]
		# Not currently using years_lapsed, but would be useful information to see within the tile box in-game
		var years_elapsed = currentYear - tile["placed_time"]
		for attr in tile["attributes"].keys():
			if attr != "name":
				var multipler = tile["multipliers"].get(attr, 0)
				# This currently multiplies the multiplier with the attribute value assigned within tiles_placed
				tile["attributes"][attr] *= (1 + tile["multipliers"][attr])
				# We could calculate current values if we don't want to update the attribute values in tiles
				# This could be a better method when implementing the repair function
				# tile["attributes"][attr] *= pow(1 + tile["multipliers"][attr], years_elapsed)

		print("Updated tile at", pos, ":", tile["attributes"])  # Debug print

# Maximum income is updated every year until we have a tile_data that allows selling
#func updateMaximumIncome():
	#var maxIncome = 0
	#for tile in tile_data.values():
		#maxIncome += tile["attributes"]["income"]
	#Global.MaximumIncome = maxIncome

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
	MaximumIncome += attributes.get("income")
	
# Array to store yearly data for line chart
var yearly_data = [] 
var happiness_data = []
var electricity_data = []
var pollution_data = []
var money_data = []

# Function to append yearly data to array yearly_data
func collect_yearly_data():
	# All relevant yearly_data stoed in year_snapshot
	var year_snapshot = {
		"Year": currentYear,
		"Money": Money,
		"Pollution": Pollution,
		"Electricity": Electricity,
		"Happiness": Happiness
	}
	# Append to array
	yearly_data.append(year_snapshot)
	
	# Add values to appropriate list for line chart
	happiness_data.append(year_snapshot["Happiness"])
	electricity_data.append(year_snapshot["Electricity"])
	pollution_data.append(year_snapshot["Pollution"])
	money_data.append(year_snapshot["Money"])
	
# Function returns they yearly_data array
func get_yearly_data():
	return yearly_data

# Final score calculaion - needs reviewing on how we do this
func calculate_final_score():
	var total_score = 0
	for data in yearly_data:
		total_score += data["Happiness"]*1
		total_score += data["Pollution"]*-0.01
		total_score += data["Money"]*0.1
	return total_score
	
func repairAirFilter():
	print(ExternalPollution)
	ExternalPollution *= AIR_FILTER_REPAIR_MULTIPLIER
	print(ExternalPollution)

func chargeMoney(amount):
	if Money < amount:
		print("Not enough molah")
		var moneyAnim = moneyAnimation.instantiate()
		add_child(moneyAnim)
		return false
	else:
		Money -= amount
		print("Charged player ",amount)
		return true
