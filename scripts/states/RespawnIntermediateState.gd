extends State

@export var living_state : State

var _finished_flag : bool = false

func extra_init() -> void:
	anim_player.animation_finished.connect(_on_animation_finished)

func enter() -> void:
	super()
	
	_finished_flag = false
	anim_player.play_animation("respawn")
	
func exit() -> void:
	super()
	
func process_frame(delta : float) -> State:
	return null
	
func process_physics(delta : float) -> State:
	if _finished_flag:
		return living_state
	
	return null

func _on_animation_finished(anim_name : StringName) -> void:
	if anim_name == "respawn":
		_finished_flag = true
