extends Node

# Runs all test scripts in the "tests" folder
func _ready():
	var dir = DirAccess.open("res://tests")
	if dir:
		dir.list_dir_begin()  # Begin listing directory contents
		var file = dir.get_next()  # Retrieve the first file
		while file != "":
			if file.ends_with(".gd") and file != "test_runner.gd":
				var test_script = load("res://tests/" + file).new()
				test_script._ready()  # Run _ready() for each test script
			file = dir.get_next()  # Move to the next file in the directory
		dir.list_dir_end()  # End listing directory contents
	print("All tests completed")