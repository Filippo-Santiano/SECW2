class_name HotkeyRebindButton
extends Control

@onready var label: Label = $HBoxContainer/Label
@onready var button: Button = $HBoxContainer/Button


@export var action_name : String = ""


func _ready():
	set_process_unhandled_key_input(false)
	
