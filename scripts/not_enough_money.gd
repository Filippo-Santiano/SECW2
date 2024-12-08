extends Label
@onready var animationPlayer = get_node("AnimationPlayer")
@onready var test = ""

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	position = get_global_mouse_position()
	animationPlayer.play("NotEnoughMoney")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	queue_free()