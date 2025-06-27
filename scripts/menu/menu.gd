class_name Menu
extends Control

var game_node : Node

func init(node : Node) -> void:
	game_node = node

func enter() -> void:
	visible = true
	
func exit() -> void:
	visible = false

func process_frame(delta : float) -> Menu:
	return null
	
func process_physics(delta : float) -> Menu:
	return null

func process_input(event : InputEvent) -> Menu:
	return null

func set_game_paused(paused : bool) -> void:
	game_node.process_mode = PROCESS_MODE_DISABLED if paused else PROCESS_MODE_INHERIT 
	GlobalCardTimer.process_mode = PROCESS_MODE_DISABLED if paused else PROCESS_MODE_INHERIT
