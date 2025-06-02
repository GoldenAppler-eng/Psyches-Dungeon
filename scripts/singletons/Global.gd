extends Node

enum EFFECT_TYPE { PSYCHE = 0, CONTROL, GOAL, NONE }
enum TASK_TYPE { DEFEAT = 0, DEFEAT_GOLD, COLLECT, OPEN, ACTIVATE, DIE, TRAVEL }
enum DIRECTION { NORTH = 3, SOUTH = 4, EAST = 5, WEST = 6 }

var global_player : Player
