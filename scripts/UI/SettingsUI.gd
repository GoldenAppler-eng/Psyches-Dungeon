extends Control

@onready var screen_distortion_controller: MarginContainer = $MarginContainer/container/screen_distortion_controller

func _ready() -> void:
	focus_entered.connect(_on_focus_entered)

func _on_focus_entered() -> void:
	screen_distortion_controller.grab_focus()
