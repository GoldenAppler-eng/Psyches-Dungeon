class_name HeartIcon
extends AnimatedSprite2D

func set_beating(beating : bool) -> void:	
	if beating:
		play("beating")
	else:
		play("dead")

func set_regen(regen : bool) -> void:	
	if regen: 
		play("regeneration")
	elif not is_beating():
		play("dead")
	elif is_beating():
		play("beating")
	
func hurt() -> void:
	play("hurt")

func play_faster_beating(fast : bool) -> void:
	if not is_beating():
		return
	
	if fast:
		play("beating_fast")
	else:
		play("beating")

func is_beating() -> bool:
	return animation == "beating" or animation == "beating_fast"

func is_regenerating() -> bool:
	return animation == "regeneration"

func _on_animation_finished() -> void:
	if animation == "hurt":
		play("dead")
