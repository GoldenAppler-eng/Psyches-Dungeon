extends Node2D

const MARKER_WIDTH : int = 32
const MARKER_HEIGHT : int = 32

const GAP_WIDTH : int = 16
const MARKERS_PER_ROW : int = 5

@export var goal_handler : GoalHandler

var goal_markers : Array[GoalMarker]

var total_active_marker_count : int = 0

func _ready() -> void:
	goal_handler.marker_added.connect(_on_marker_added)
	goal_handler.marker_removed.connect(_on_marker_removed)
	goal_handler.markers_reset.connect(_on_markers_reset)

	goal_handler.goal_marked.connect(_on_goal_marked)

	detect_markers()
	initialize_markers()
	space_markers()

func detect_markers() -> void:
	for marker : GoalMarker in get_children():
		goal_markers.append(marker)

func initialize_markers() -> void:
	for marker in goal_markers:
		marker.set_active(false)

func space_markers() -> void:
	for i in goal_markers.size():
		var marker : GoalMarker = goal_markers[i]
		
		marker.position.x = (i % MARKERS_PER_ROW) * (MARKER_WIDTH + GAP_WIDTH)  
		marker.position.y = (i / MARKERS_PER_ROW) * (MARKER_HEIGHT + GAP_WIDTH)

func _on_marker_added() -> void:	
	goal_markers[total_active_marker_count].set_active(true)
	total_active_marker_count += 1
	
func _on_marker_removed() -> void:
	goal_markers[total_active_marker_count].set_active(false)
	total_active_marker_count -= 1
	
func _on_markers_reset() -> void:	
	initialize_markers()
	total_active_marker_count = 0

func _on_goal_marked(marker_index : int, goal_type : int) -> void:
	goal_markers[marker_index].set_icon(goal_type)
