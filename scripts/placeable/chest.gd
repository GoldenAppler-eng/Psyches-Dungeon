extends StaticBody2D

const LUCKY_OPEN_CHANCE : float = 0.8

@onready var coin_summoner_component: SummonerComponent = %CoinSummonerComponent
@onready var enemy_summoner_component: SummonerComponent = %EnemySummonerComponent

@onready var animated_sprite_2d : AnimatedSprite2D = $%AnimatedSprite2D
@onready var open_sfx : AudioStreamPlayer = $OpenSfx
@onready var open_buffer_timer: Timer = %OpenBufferTimer

var _player_nearby := false
var _opened := false

func _ready() -> void:
	animated_sprite_2d.frame = 0

func _process(delta: float) -> void:
	if not _player_nearby or _opened:
		return

	if Input.is_action_just_pressed("open_chest"):
		_open_chest()

func _open_chest() -> void:
	GlobalSignalBus.chest_opened.emit()
	
	_opened = true
	animated_sprite_2d.frame = 2	
	
	open_sfx.play()

	if randf() < LUCKY_OPEN_CHANCE: 
		coin_summoner_component.summon_multiple(randi_range(1, 3), true)
	else:
		enemy_summoner_component.summon_multiple(randi_range(1, 2), true)

func _on_area_2d_player_entered(body: Node2D) -> void:
	if _opened:
		return
	
	_player_nearby = true
	animated_sprite_2d.frame = 1

func _on_area_2d_player_exited(body: Node2D) -> void:
	if _opened:
		return
	
	open_buffer_timer.start()

func _on_open_buffer_timer_timeout() -> void:
	_player_nearby = false
	animated_sprite_2d.frame = 0
