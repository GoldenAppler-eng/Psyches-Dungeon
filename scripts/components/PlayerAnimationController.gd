extends AnimationController

signal animation_finished(anim_name : StringName)

@export var top_half_sprite : AnimatedSprite2D 
@export var bottom_half_sprite : AnimatedSprite2D

@export var animation_player : AnimationPlayer

func play_animation(anim_name : StringName) -> void:
	match anim_name:
		"idle":
			if top_half_sprite.animation == "attack":
				bottom_half_sprite.play("attack")
			else:
				_sync_play_animation(anim_name, false)			
		"run":
			if top_half_sprite.animation == "attack":
				bottom_half_sprite.play("run")
			else:
				_sync_play_animation(anim_name, false)	
		"attack":
			top_half_sprite.play(anim_name)
			
			if bottom_half_sprite.animation == "idle":
				_sync_play_animation(anim_name, true)
		"hit":
			animation_player.play(anim_name)
	
func flip_animation_h(flipped : bool) -> void:
	top_half_sprite.flip_h = flipped
	bottom_half_sprite.flip_h = flipped

func _sync_play_animation(anim_name : StringName, follow_top : bool) -> void:
	top_half_sprite.play(anim_name)
	bottom_half_sprite.play(anim_name)
	
	if follow_top:
		bottom_half_sprite.frame = top_half_sprite.frame
	else:
		top_half_sprite.frame = bottom_half_sprite.frame
