extends Control

# Called when the node enters the scene tree for the first time.
func resume():
	get_tree().paused = false
	visible = false
	$AnimationPlayer.play_backwards("blur")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func pause():
	visible = true
	get_tree().paused = true
	$AnimationPlayer.play("blur")

func testEsc():
	if Input.is_action_just_pressed("esc") and !get_tree().paused:
		pause()
	elif Input.is_action_just_pressed("esc") and get_tree().paused:
		resume()


func _on_resume_pressed() -> void:
	resume()

func _on_quit_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://menus/main_menu/main_menu.tscn")

func _process(delta):
	testEsc()
