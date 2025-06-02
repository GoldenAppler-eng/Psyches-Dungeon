class_name Card
extends Node2D

var task_text : String = ""
var effect_text : String = ""
@export var effect_type : int = 4
@export var face_down : bool

@onready var base : AnimatedSprite2D = $%base
@onready var effect_icon : AnimatedSprite2D = $%effect_icon

@onready var task_text_label : Label = $%task_text_label
@onready var effect_text_label : Label = $%effect_text_label


func _process(delta : float) -> void:
	effect_icon.frame = effect_type
	
	task_text_label.text = task_text
	effect_text_label.text = effect_text
	
