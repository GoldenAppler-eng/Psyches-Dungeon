extends State

@export var summoner_component : SummonerComponent
@export var enemy : Enemy

var enemy_is_golden : bool = false

func extra_init() -> void:
	enemy_is_golden = enemy._is_golden

func enter() -> void:
	super()
	
	anim_player.play_animation("death")
	GlobalSignalBus.enemy_death.emit(enemy_is_golden)
	
	if enemy_is_golden:
		summoner_component.summon(true)
	
func exit() -> void:
	super()
		
func process_frame(delta : float) -> State:
	return null
	
func process_physics(delta : float) -> State:
	return null
