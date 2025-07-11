class_name HeartIcon
extends AnimatedSprite2D

func set_regen(regen : bool) -> void:
	if regen: 
		play("regeneration")
	elif not is_beating():
		play("dead")
		
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
