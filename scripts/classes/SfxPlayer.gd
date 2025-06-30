class_name SfxPlayer
extends Node

var sfx_list : Dictionary = {}

func init() -> void:
	initialize_sfx_list()

func play_sfx(sfx_name : String) -> void:
	var sfx_stream : AudioStreamPlayer = sfx_list[sfx_name]
	sfx_stream.play()
	
func initialize_sfx_list() -> void:
	for sfx_stream : AudioStreamPlayer in get_children():
		sfx_list.set(sfx_stream.name, sfx_stream)
		
	sfx_list.make_read_only()
