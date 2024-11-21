extends Node

var Money = 10
var Pollution = 0

var currentYear : float

var YearlyPollution: = 0
var placed_tiles: Array = []
var Income = 0


func updatePollution():
	var total_yearly_pollution = 0
	for i in placed_tiles:
		total_yearly_pollution += i.yearly_pollution
	YearlyPollution = total_yearly_pollution
	#print("Recalculated Yearly Pollution:", Global.YearlyPollution)
	
func updateIncome():
	var total_yearly_income = 0
	for i in placed_tiles:
		total_yearly_income += i.yearly_income
	Income = total_yearly_income
	
func addNewTile(tile,initial_pollution):
	Pollution += initial_pollution
	
	var new_tile = Tile.new() #creates an instance of the Tile class, with
	new_tile.id = tile #id of the tile being placed.
	new_tile.initialise_pollution()
	new_tile.initialise_income() #then sets the pollution/income variables based on the ID
	placed_tiles.append(new_tile) #and adds that tile to the global placed_tiles array.
	#this is used for adding pollution/income yearly

func updateData():
	updatePollution()
	updateIncome()
