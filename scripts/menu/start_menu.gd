extends Menu

@onready var start_blink_timer : Timer =  %StartBlinkTimer
@onready var start_label : Label = %start_label

func enter() -> void:
	super()
	
func exit() -> void:
	super()

func _on_start_blink_timer_timeout() -> void:
	start_label.visible = not start_label.visible
