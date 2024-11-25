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
			var multipler = tile["multipliers"].get(attr, 0)
			print("£££££££££££££££££££££££££££££££££££££££££££££££")
			print("Attribute: ", attr)
			print("Attribute value: ", tile["attributes"][attr])
			print("Multipliers: ", tile["multipliers"][attr])
			# This currently multiplies the multiplier with the attribute value assigned within tiles_placed
			tile["attributes"][attr] *= (1 + tile["multipliers"][attr])
			# We could calculate current values if we don't want to update the attribute values in tiles
			# This could be a better method when implementing the repair function
			# tile["attributes"][attr] *= pow(1 + tile["multipliers"][attr], years_elapsed)

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
