extends Label
var visualYears = 0
@export var YearsTimer : Timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	text = str("Year: ",visualYears)


func _on_years_timer_timeout() -> void:
	visualYears = int(YearsTimer.Years)
	text = str("Year: ",visualYears)
