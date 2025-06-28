class_name SettingsUI
extends Control

@onready var resolution_controller: MarginContainer = $MarginContainer/container/resolution_controller

func _ready() -> void:
	focus_entered.connect(_on_focus_entered)

func _on_focus_entered() -> void:
	resolution_controller.grab_focus()
