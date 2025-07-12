extends Node


enum EFFECT_TYPE { PSYCHE = 0, CONTROL, GOAL, NONE }
enum DIRECTION { NORTH = 3, SOUTH = 4, EAST = 5, WEST = 6 }

var global_player : Player

const INIT_NUM_GOAL := 5
const MIN_NUM_GOAL := 1
