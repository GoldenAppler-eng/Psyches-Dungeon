extends Node2D

@export var room_prefab : PackedScene
@export var empty_room_prefab : PackedScene

enum DIRECTION { NORTH = 3, SOUTH = 4, EAST = 5, WEST = 6 }
enum ROOM_STATUS { NOT_PROCESSED = 0, PROCESSED_EMPTY, PROCESSED_FILLED }
enum ROOM_TYPE { EMPTY = 0, FILLED }

const ANTI_CONNECTOR_LAYER = 13

const ROOM_WIDTH := 512
const ROOM_HEIGHT := 320

const ROOM_GEN_CHANCE := .5

var rooms_to_process : Array[Node2D]
var rooms_to_generate_surrounding : Array[Node2D]

func _ready() -> void:	
	GlobalSignalBus.room_changed.connect(_on_room_changed)
	
	var init_room := _generate_room(0, 0, ROOM_TYPE.FILLED)

	rooms_to_generate_surrounding.append(init_room)
	
func _process(delta : float) -> void:
	if rooms_to_process:
		for room in rooms_to_process:
			_send_off_room_connectors(room)
		
		rooms_to_process = []
		
	if rooms_to_generate_surrounding:
		for room in rooms_to_generate_surrounding:
			_generate_surrounding_rooms(room)
			rooms_to_process.append(room)
			
		rooms_to_generate_surrounding = []

func _send_off_room_connectors(room : Node2D) -> void:
	for i : int in DIRECTION.values():
		var direction_str : String 
		
		match i:
			DIRECTION.NORTH:
				direction_str = "north"
			DIRECTION.SOUTH:
				direction_str = "south"
			DIRECTION.EAST:
				direction_str = "east"
			DIRECTION.WEST:
				direction_str = "west"
					
		var connector : Area2D = room.get_node_or_null(direction_str + "_connector") as Area2D
		
		connector.monitoring = false

func _generate_room(world_coord_x : float, world_coord_y : float, type : int) -> Node2D :
	var room : Node2D
	
	match type:
		ROOM_TYPE.EMPTY:
			room = empty_room_prefab.instantiate() as Node2D
		ROOM_TYPE.FILLED:
			room = room_prefab.instantiate() as Node2D
	
	get_parent().add_child.call_deferred(room)
	
	room.global_position = Vector2(world_coord_x, world_coord_y)

	return room

func _generate_room_in_direction(origin_room : Node2D, direction : int, type : int) -> Node2D:
	var delta_x : float = 0
	var delta_y : float = 0
	
	match direction:
		DIRECTION.NORTH:
			delta_y = -ROOM_HEIGHT
		DIRECTION.SOUTH:
			delta_y = ROOM_HEIGHT
		DIRECTION.EAST:
			delta_x = ROOM_WIDTH
		DIRECTION.WEST:
			delta_x = -ROOM_WIDTH
		
	var world_coord_x : float = origin_room.global_position.x + delta_x
	var world_coord_y : float = origin_room.global_position.y + delta_y
	
	var room := _generate_room(world_coord_x, world_coord_y, type)
	
	return room

func _generate_surrounding_rooms(origin_room : Node2D) -> void:
	var has_rooms := _check_surroundings(origin_room)
	
	var guaranteed_direction : int = -1
	
	var empty_space_indices : Array[int]
	
	for i in has_rooms.size():
		if has_rooms[i] == ROOM_STATUS.NOT_PROCESSED:
			empty_space_indices.append(i)
		else:
			var direction : int = i + DIRECTION.NORTH
			
			if has_rooms[i] == ROOM_STATUS.PROCESSED_FILLED:
				_set_door_in_direction(origin_room, direction, false)
			else:
				_set_door_in_direction(origin_room, direction, true)
	
	if (empty_space_indices.is_empty()):
		return
		
	var random_empty_space_index : int = empty_space_indices.pick_random()
	
	guaranteed_direction = random_empty_space_index + DIRECTION.NORTH
	_generate_room_in_direction(origin_room, guaranteed_direction, ROOM_TYPE.FILLED)
	_set_door_in_direction(origin_room, guaranteed_direction, false)
	
	empty_space_indices.remove_at(empty_space_indices.find(random_empty_space_index))
	
	for index in empty_space_indices:
		var rng : float = randf()
		
		var direction : int = index + DIRECTION.NORTH
		
		if rng < ROOM_GEN_CHANCE:
			_generate_room_in_direction(origin_room, direction, ROOM_TYPE.FILLED)
			_set_door_in_direction(origin_room, direction, false)
		else:
			_generate_room_in_direction(origin_room, direction, ROOM_TYPE.EMPTY)
			_set_door_in_direction(origin_room, direction, true)

func _check_surroundings(room : Node2D) -> Array[int]:
	var has_rooms : Array[int] = [ROOM_STATUS.NOT_PROCESSED, ROOM_STATUS.NOT_PROCESSED, ROOM_STATUS.NOT_PROCESSED, ROOM_STATUS.NOT_PROCESSED]
	
	for i : int in DIRECTION.values():
		var direction_str : String 
		
		match i:
			DIRECTION.NORTH:
				direction_str = "north"
			DIRECTION.SOUTH:
				direction_str = "south"
			DIRECTION.EAST:
				direction_str = "east"
			DIRECTION.WEST:
				direction_str = "west"
					
		var connector : Area2D = room.get_node_or_null(direction_str + "_connector") as Area2D
		var index : int = i - DIRECTION.NORTH
		
		if connector.has_overlapping_areas():
			for area in connector.get_overlapping_areas():
				if area.get_collision_layer_value(ANTI_CONNECTOR_LAYER):
					has_rooms[index] = 	ROOM_STATUS.PROCESSED_EMPTY
					break
				else:
					has_rooms[index] = ROOM_STATUS.PROCESSED_FILLED
					break
	
	return has_rooms
	
func _set_door_in_direction(room : Node2D, direction : int, closed : bool) -> void:
	var tilemap : TileMap
	
	for child in room.get_children():
		if child is TileMap:
			tilemap = child as TileMap
			break

	if not tilemap:
		return	
		
	var direction_str : String
	
	tilemap.set_layer_enabled(direction, closed)

func _on_room_changed(direction : int, room_area : Node2D) -> void:
	var room : Node2D = room_area.owner
	
	if rooms_to_process.has(room) or rooms_to_generate_surrounding.has(room):
		return
	
	var sample_connector : Area2D = room.get_node_or_null("north_connector") as Area2D
	
	if sample_connector.monitoring:
		rooms_to_generate_surrounding.append(room_area.owner)
