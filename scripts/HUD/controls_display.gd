extends Node2D

@onready var up_sprite : AnimatedSprite2D = $%up
@onready var down_sprite : AnimatedSprite2D = $%down
@onready var left_sprite : AnimatedSprite2D = $%left
@onready var right_sprite : AnimatedSprite2D = $%right

func _ready() -> void:
	GlobalSignalBus.revert_controls.connect(revert)
	GlobalSignalBus.invert_controls.connect(invert)
	GlobalSignalBus.shift_controls.connect(shift)

func revert() -> void:
	up_sprite.frame = 0
	down_sprite.frame = 1
	right_sprite.frame = 2
	left_sprite.frame = 3

func invert() -> void:
	up_sprite.frame = 1
	down_sprite.frame = 0
	right_sprite.frame = 3
	left_sprite.frame = 2

func shift() -> void:
	up_sprite.frame = 3
	down_sprite.frame = 2
	right_sprite.frame = 0
	left_sprite.frame = 1
