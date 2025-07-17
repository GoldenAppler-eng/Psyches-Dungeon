extends Node

enum EFFECT_TYPE { PSYCHE = 0, CONTROL, GOAL, HEART, LUCK, NONE}
enum DIRECTION { NORTH = 3, SOUTH = 4, EAST = 5, WEST = 6 }

var global_player : Player

const MAX_TIME_LIMIT : int = 15

var screen_distortion_enabled : bool = true

var lucky_flag : bool = false
var unlucky_flag : bool = false

var gold_rush_flag : bool = false

var double_marker_flag : bool = false
