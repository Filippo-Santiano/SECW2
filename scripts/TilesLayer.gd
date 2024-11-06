extends TileMapLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func placeTile(tile,x,y):
	set_cell(Vector2i(x,y),tile,Vector2i(0,0))
# set_cell takes the tile position, ID of the tile, and the position in the texture atlas of the tile you're using.
# Right now, we're just using an atlas for each tile. We might change that later, but for the time being
# that stays as just (0,0)

func clearTile(x,y):
	erase_cell(Vector2i(x,y))
