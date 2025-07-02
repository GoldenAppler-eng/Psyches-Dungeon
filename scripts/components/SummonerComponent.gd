class_name SummonerComponent
extends Node2D

@export var summoned_prefab : PackedScene
@export var summoner_node : Node2D

var jump_component_prefab : PackedScene = preload("res://prefabs/components/JumpComponent.tscn")

func summon(jump_summon : bool) -> void:
	var item : Node = summoned_prefab.instantiate()	
	summoner_node.add_child(item)	
	
	if jump_summon:
		var jump_comp : Node = jump_component_prefab.instantiate()
		item.add_child(jump_comp)
		
	item.global_position = summoner_node.global_position

func summon_multiple(num : int, jump_summon : bool) -> void:
	for i in num:
		summon(jump_summon)
