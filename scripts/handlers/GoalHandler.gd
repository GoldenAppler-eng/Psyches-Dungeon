class_name GoalHandler
extends Node2D

signal marker_added
signal marker_removed
signal goal_marked(marker_index : int, goal_type : int)
signal markers_reset

const MIN_MARKER_COUNT : int = 3
const INITIAL_MARKER_COUNT : int = 5
const MAX_MARKER_COUNT : int = 10

enum GOAL_TYPE { PSYCHE = 0, CONTROL, GOAL, HEART, LUCK, NONE, FAIL }

@onready var game_over_timer: Timer = $GameOverTimer

var goal_marker_types : Array[int]

var goal_completion_counter : int = 0
var total_marker_count : int = 0

var failing : bool = false

func _ready() -> void:
	GlobalSignalBus.change_goal_count.connect(_on_goal_count_changed)
	GlobalSignalBus.retry.connect(_on_game_retry)
	GlobalSignalBus.game_start.connect(_on_game_start)
	
	game_over_timer.timeout.connect(_on_game_over_timer_timeout)
	
func _on_game_start() -> void:
	goal_marker_types = []
	reset_marker_types()
	initialize_markers()

func _on_game_retry() -> void:
	reset_marker_types()
	initialize_markers()

func initialize_markers() -> void:
	while total_marker_count < INITIAL_MARKER_COUNT:
		add_marker()

func reset_marker_types() -> void:
	goal_completion_counter = 0
	total_marker_count = 0
	goal_marker_types.clear()
	
	markers_reset.emit()

func mark_finished_task(effect_type : int) -> void:
	if goal_completion_counter >= goal_marker_types.size():
		return
	
	if goal_completion_counter == 0:
		failing = false
	
	if failing:
		goal_completion_counter -= 1
		
		goal_marker_types[goal_completion_counter] = GOAL_TYPE.NONE
		goal_marked.emit(goal_completion_counter, goal_marker_types[goal_completion_counter])
	else:
		goal_marker_types[goal_completion_counter] = effect_type
		goal_marked.emit(goal_completion_counter, goal_marker_types[goal_completion_counter])
		
		goal_completion_counter += 1
		
	_start_game_over_countdown()

func mark_failed_task() -> void:
	if goal_completion_counter >= goal_marker_types.size():
		return
	
	if goal_completion_counter == 0:
		failing = true
	
	if not failing:
		goal_completion_counter -= 1
		
		goal_marker_types[goal_completion_counter] = GOAL_TYPE.NONE
		goal_marked.emit(goal_completion_counter, goal_marker_types[goal_completion_counter])
		
		if goal_completion_counter == 0:
			failing = false
	else:
		goal_marker_types[goal_completion_counter] = GOAL_TYPE.FAIL
		goal_marked.emit(goal_completion_counter, goal_marker_types[goal_completion_counter])
		
		goal_completion_counter += 1
		
	_start_game_over_countdown()

func _start_game_over_countdown() -> void:
	game_over_timer.start()

func _on_game_over_timer_timeout() -> void:
	if goal_completion_counter < goal_marker_types.size():
		return
		
	if failing:
		GlobalSignalBus.game_over.emit()
	else:
		GlobalSignalBus.game_win.emit()

func add_marker() -> void:
	if total_marker_count >= MAX_MARKER_COUNT:
		return
	
	goal_marker_types.append(GOAL_TYPE.NONE)
	total_marker_count += 1
	
	marker_added.emit()
	
func remove_marker() -> void:
	if total_marker_count <= MIN_MARKER_COUNT:
		return
	
	goal_marker_types.pop_back()
	total_marker_count -= 1
	
	marker_removed.emit()

func _on_goal_count_changed(inc_amt : int) -> void:
	if inc_amt > 0:
		add_marker()
	elif inc_amt < 0:
		remove_marker()
