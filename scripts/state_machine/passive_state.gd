extends State

@export var attack_state : State

@export var attack_cooldown_timer : Timer

var attack_ready := true

func init(controller : InputController, anim_player : AnimationPlayer, sfx_player : SfxPlayer) -> void:
	super(controller, anim_player, sfx_player)
	
	attack_cooldown_timer.timeout.connect(_on_attack_cooldown_timer_timeout)

func enter() -> void:
	super()
	
func exit() -> void:
	super()
	
	attack_ready = false
	attack_cooldown_timer.start()
	
func process_frame(delta : float) -> State:
	return null
	
func process_physics(delta : float) -> State:
	if controller.get_attack_request() and attack_ready:
		return attack_state
	
	return null

func _on_attack_cooldown_timer_timeout() -> void:
	attack_ready = true
