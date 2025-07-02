extends AnimationController

@export var sprite : AnimatedSprite2D
@export var animation_player : AnimationPlayer

func extra_init() -> void:
	sprite.animation_finished.connect(_on_animated_sprite_animation_finished)

func play_animation(anim_name : StringName) -> void:
	match anim_name:
		"hit":
			pass
		_:
			sprite.play(anim_name)
	
func play_animation_overlay(overlay_name : StringName) -> void:
	match overlay_name:
		"hit":
			animation_player.play(overlay_name)
	
func clear_all_animation_overlay() -> void:
		animation_player.play("RESET")	

func flip_animation_h(flipped : bool) -> void:
	sprite.flip_h = flipped

func _on_animated_sprite_animation_finished() -> void:
	animation_finished.emit(sprite.animation)
