extends Node2D
var currentLayer : TileMapLayer
@export var sprite : Sprite2D

signal waited
var waiting = false
var initialYear = 0
var timeToBuild = 0
const IN_PROGRESS_ID = 26

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if waiting:
		wait()

func wait():
	if Global.currentYear >= initialYear + timeToBuild:
		emit_signal("waited")
		waiting = false

func place(tile,x,y):
	if timeToBuild > 0:
		currentLayer.placeTile(IN_PROGRESS_ID,x,y)
		print("Placed construction tile")
		waiting = true
		await(waited)
		currentLayer.clearTile(x,y)
		currentLayer.placeTile(tile,x,y)
	else:
		currentLayer.placeTile(tile,x,y)
