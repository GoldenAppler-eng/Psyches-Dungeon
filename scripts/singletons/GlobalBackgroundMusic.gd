extends AudioStreamPlayer

const soundtrack_list : Dictionary = {
	"in-game" : preload("res://audio/music/salvationquestionmarkv2.wav"),
	"start menu" : preload("res://audio/music/enterthedungeon.wav"),
	"game lose" : preload("res://audio/music/psychewins.wav"),
	"game win" : preload("res://audio/music/salvationexclamationmark.wav")
}

func play_soundtrack(soundtrack : StringName) -> void:
	stream = soundtrack_list[soundtrack]
	play()

func change_playback_speed(speed : float) -> void:
	pitch_scale = speed
	
func _on_finished() -> void:
	play()
