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
signal task_completed

signal player_respawn

signal retry
signal game_over
signal game_win
signal game_start

signal change_goal_count(inc_amt : int)
signal psyche_task_request
signal timer_hidden

signal invert_controls
signal shift_controls
signal revert_controls
