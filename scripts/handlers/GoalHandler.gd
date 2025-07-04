class_name GoalHandler
extends Node2D

signal marker_added
signal marker_removed
signal goal_marked(marker_index : int, goal_type : int)
signal markers_reset

const MIN_MARKER_COUNT : int = 3
const INITIAL_MARKER_COUNT : int = 5
const MAX_MARKER_COUNT : int = 10

enum GOAL_TYPE { PSYCHE = 0, CONTROL, GOAL, NONE, FAIL }

var goal_marker_types : Array[int]

var goal_completion_counter : int = 0
var total_marker_count : int = 0

func _ready() -> void:
	GlobalSignalBus.change_goal_count.connect(_on_goal_count_changed)
	GlobalSignalBus.retry.connect(_on_game_retry)
	GlobalSignalBus.game_start.connect(_on_game_start)

func _process(delta : float) -> void:
	pass
	
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
	
	goal_marker_types[goal_completion_counter] = effect_type
	goal_marked.emit(goal_completion_counter, 	goal_marker_types[goal_completion_counter])
	
	goal_completion_counter += 1
	
	if goal_completion_counter >= goal_marker_types.size():
		GlobalSignalBus.game_win.emit()

func mark_failed_task() -> void:
	goal_marker_types[goal_completion_counter] = GOAL_TYPE.FAIL
	goal_marked.emit(goal_completion_counter, 	goal_marker_types[goal_completion_counter])

	goal_completion_counter += 1

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
