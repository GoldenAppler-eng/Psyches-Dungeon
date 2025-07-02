extends State

@export var summoner_component : SummonerComponent

func enter() -> void:
	super()
	
	summoner_component.summon(true)
	
	anim_player.play("death")
	GlobalSignalBus.enemy_death.emit(true)
	
func exit() -> void:
	super()
		
func process_frame(delta : float) -> State:
	return null
	
func process_physics(delta : float) -> State:
	return null
