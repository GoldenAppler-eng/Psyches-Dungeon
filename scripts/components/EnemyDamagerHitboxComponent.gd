extends DamagerHitboxComponent

@export var attack_detection_area : Area2D

var attack_detection_area_offset : float

func _ready() -> void:
	super()
	attack_detection_area_offset = attack_detection_area.position.x

func flip_hitbox_h(flipped : bool) -> void:
	super(flipped)
	attack_detection_area.position.x = -attack_detection_area_offset if flipped else attack_detection_area_offset;
