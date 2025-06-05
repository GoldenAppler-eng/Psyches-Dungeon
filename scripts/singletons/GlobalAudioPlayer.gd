extends Node

@onready var card_draw_sfx_player : AudioStreamPlayer = %CardDrawSfxPlayer
@onready var chest_open_sfx_player : AudioStreamPlayer = $%ChestOpenSfxPlayer
@onready var coin_pickup_sfx_player : AudioStreamPlayer = $%CoinPickupSfxPlayer
@onready var complete_mission_sfx_player : AudioStreamPlayer = $%CompleteMissionSfxPlayer
@onready var enemy_attack_sfx_player : AudioStreamPlayer = $%EnemyAttackSfxPlayer
@onready var enemy_hit_sfx_player : AudioStreamPlayer = $%EnemyHitSfxPlayer
@onready var fail_mission_sfx_player : AudioStreamPlayer = $%FailMissionSfxPlayer
@onready var player_attack_sfx_player : AudioStreamPlayer = $%PlayerAttackSfxPlayer
@onready var player_hit_sfx_player : AudioStreamPlayer = $%PlayerHitSfxPlayer
@onready var run_sfx_player : AudioStreamPlayer = $%RunSfxPlayer
@onready var timer_sfx_player : AudioStreamPlayer = $%TimerSfxPlayer
@onready var trap_activate_sfx_player : AudioStreamPlayer = $%TrapActivateSfxPlayer
@onready var death_1_sfx_player : AudioStreamPlayer = $%Death1SfxPlayer
@onready var death_2_sfx_player : AudioStreamPlayer = $%Death2SfxPlayer
@onready var death_3_sfx_player : AudioStreamPlayer = $%Death3SfxPlayer
@onready var game_over_1_sfx_player : AudioStreamPlayer = $%GameOver1SfxPlayer
@onready var game_over_2_sfx_player : AudioStreamPlayer = $%GameOver2SfxPlayer
@onready var game_over_3_sfx_player : AudioStreamPlayer = $%GameOver3SfxPlayer
@onready var game_over_4_sfx_player : AudioStreamPlayer = $%GameOver4SfxPlayer
@onready var laugh_1_sfx_player : AudioStreamPlayer = $%Laugh1SfxPlayer
@onready var laugh_2_sfx_player : AudioStreamPlayer = $%Laugh2SfxPlayer
@onready var laugh_3_sfx_player : AudioStreamPlayer = $%Laugh3SfxPlayer
@onready var laugh_4_sfx_player : AudioStreamPlayer = $%Laugh4SfxPlayer
@onready var psyche_1_sfx_player : AudioStreamPlayer = $%Psyche1SfxPlayer
@onready var psyche_2_sfx_player : AudioStreamPlayer = $%Psyche2SfxPlayer
@onready var salvation_1_sfx_player : AudioStreamPlayer = $%Salvation1SfxPlayer
@onready var salvation_2_sfx_player : AudioStreamPlayer = $%Salvation2SfxPlayer

var sfx_dict : Dictionary

func _ready() -> void:
	sfx_dict = {
		"card_draw" : card_draw_sfx_player,
		"chest_open" : chest_open_sfx_player,
		"coin_pickup" : coin_pickup_sfx_player,
		"complete_mission" : complete_mission_sfx_player,
		"enemy_attack" : enemy_attack_sfx_player,
		"enemy_hit" : enemy_hit_sfx_player,
		"fail_mission" : fail_mission_sfx_player,
		"player_attack" : player_attack_sfx_player,
		"player_hit" : player_hit_sfx_player,
		"run" : run_sfx_player,
		"timer" : timer_sfx_player,
		"trap_activate" : trap_activate_sfx_player,
		"death_1" : death_1_sfx_player,
		"death_2" : death_2_sfx_player,
		"death_3" : death_3_sfx_player,
		"game_over_1" : game_over_1_sfx_player,
		"game_over_2" : game_over_2_sfx_player,
		"game_over_3" : game_over_3_sfx_player,
		"game_over_4" : game_over_4_sfx_player,
		"laugh_1" : laugh_1_sfx_player,
		"laugh_2" : laugh_2_sfx_player,
		"laugh_3" : laugh_3_sfx_player,
		"laugh_4" : laugh_4_sfx_player,
		"psyche_1" : psyche_1_sfx_player,
		"psyche_2" : psyche_2_sfx_player,
		"salvation_1" : salvation_1_sfx_player,
		"salvation_2" : salvation_2_sfx_player 
	}
	
	for sfx_name : String in sfx_dict.keys():
		var sfx_player : SignalSfxPlayer = sfx_dict[sfx_name]
		sfx_player.set_sfx_name(sfx_name)
	
func play_sfx(sfx_name : String) -> void:
	var sfx_player : AudioStreamPlayer = sfx_dict[sfx_name]
	sfx_player.play()

