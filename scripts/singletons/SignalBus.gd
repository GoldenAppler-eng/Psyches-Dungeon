class_name SignalBus
extends Node

signal coin_collected
signal chest_opened
signal trap_activated(activating_body : Node2D)
signal enemy_death(is_gold : bool)
signal player_death
signal room_exited(room_area : Node2D)
signal room_entered(room_area : Node2D)
signal room_changed(direction : int, room_area : Node2D)
signal task_completed(task_type : int)

signal change_goal_count(inc_amt : int)
signal psyche_task_request

signal invert_controls
signal shift_controls
signal revert_controls
