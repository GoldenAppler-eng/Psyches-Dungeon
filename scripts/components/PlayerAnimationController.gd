extends AnimationController

@export var top_half_sprite : AnimatedSprite2D 
@export var bottom_half_sprite : AnimatedSprite2D

@export var animation_player : AnimationPlayer

func play_animation(anim_name : StringName) -> void:
	_clean_previous_animation()
	
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
			pass
		"death":
			_play_top_half_animation_only(anim_name)
		"respawn":
			_play_top_half_animation_only(anim_name)
	
func flip_animation_h(flipped : bool) -> void:
	top_half_sprite.flip_h = flipped
	bottom_half_sprite.flip_h = flipped

func play_current_animation() -> void:
	if bottom_half_sprite.animation == "attack":
		_sync_play_animation("idle", false)
	else:
		_sync_play_animation(bottom_half_sprite.animation, false)

func play_animation_overlay(overlay_name : StringName) -> void:
	match overlay_name:
		"hit":
			animation_player.play.call_deferred(overlay_name)
		"invincible":
			animation_player.play.call_deferred(overlay_name)
			
func clear_all_animation_overlay() -> void:
	animation_player.play("RESET")

func _sync_play_animation(anim_name : StringName, follow_top : bool) -> void:
	top_half_sprite.play(anim_name)
	bottom_half_sprite.play(anim_name)
	
	if follow_top:
		bottom_half_sprite.frame = top_half_sprite.frame
	else:
		top_half_sprite.frame = bottom_half_sprite.frame

func _clean_previous_animation() -> void:
	bottom_half_sprite.visible = true

func _play_top_half_animation_only(anim_name : StringName) -> void:
	top_half_sprite.play(anim_name)
	bottom_half_sprite.visible = false

func extra_init() -> void:
	top_half_sprite.animation_finished.connect(_on_top_half_animation_finished)

func _on_top_half_animation_finished() -> void:
	animation_finished.emit(top_half_sprite.animation)
