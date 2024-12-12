extends Area2D

#Set the mouseBlocker variable when the mouse enters and exits the box

func _on_mouse_entered() -> void:
	Global.mouseBlocker = true


func _on_mouse_exited() -> void:
	Global.mouseBlocker = false

func _ready() -> void:
	enable()

func disable():
	$MenuShape.disabled = true
	$ButtonShape.disabled = true
	$RepairButtonShape.disabled = true

func enable():
	$MenuShape.disabled = false
	$ButtonShape.disabled = false
	$RepairButtonShape.disabled = false
