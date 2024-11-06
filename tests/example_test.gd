extends SceneTree

func add(a: int, b: int) -> int:
	return a + b

func _ready():
	assert(add(1, 1) == 2, "1 + 1 should equal 2")
	assert(add(2, 3) == 5, "2 + 3 should equal 5")
	print("Example test succeeded")
