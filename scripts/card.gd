class_name Card
extends Node2D

var task_text : String
var effect_text : String
@export var effect_type : int = 4
@export var face_down : bool

@onready var base : AnimatedSprite2D = $%base
@onready var effect_icon : AnimatedSprite2D = $%effect_icon

func _process(delta : float) -> void:
	effect_icon.frame = effect_type
