extends StaticBody2D

@export var enemy_prefab : PackedScene
@export var coin_prefab : PackedScene
@export var jump_component_prefab : PackedScene

@onready var animated_sprite_2d : AnimatedSprite2D = $%AnimatedSprite2D
@onready var open_sfx : AudioStreamPlayer = $OpenSfx

var _player_nearby := false
var _opened := false

func _process(delta: float) -> void:
	if not _player_nearby or _opened:
		return
		
	animated_sprite_2d.frame = 0	
		
	if Input.is_action_just_pressed("open_chest"):
		_open_chest()

func _open_chest() -> void:
	GlobalSignalBus.chest_opened.emit()
	
	_opened = true
	animated_sprite_2d.frame = 1	
	
	open_sfx.play()
	
	var rng := randf()
	
	if rng < 0.8: 
		_spawn(coin_prefab, randi_range(1, 3))
	else:
		_spawn(enemy_prefab, randi_range(1, 3))

func _spawn(prefab : PackedScene, num : int) -> void:
	for i in num:
		var spawned : Node2D = prefab.instantiate()
		var jump_comp : Node2D = jump_component_prefab.instantiate()
		
		get_parent().add_child(spawned)
		spawned.global_position = global_position
		
		spawned.add_child(jump_comp)

func _on_area_2d_player_entered(body: Node2D) -> void:
	_player_nearby = true

func _on_area_2d_player_exited(body: Node2D) -> void:
	_player_nearby = false
