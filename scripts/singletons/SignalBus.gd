class_name SignalBus
extends Node

signal coin_collected
signal chest_opened
signal trap_activated(activated_by_body : Node2D)
signal enemy_death(is_gold : bool)
signal room_changed(direction : int, room_area : Node2D)
signal task_completed(task_type : int)
