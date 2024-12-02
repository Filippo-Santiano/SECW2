extends Area2D

#Set the mouseBlocker variable when the mouse enters and exits the box

func _on_mouse_entered() -> void:
	Global.mouseBlocker = true


func _on_mouse_exited() -> void:
	Global.mouseBlocker = false
