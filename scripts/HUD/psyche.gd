extends Node2D

@onready var animated_sprite_2d : AnimatedSprite2D = $%AnimatedSprite2D
@onready var audio_player : AudioStreamPlayer = $%AudioPlayer

var audio_dict : Dictionary = {
	"death_1" : load("res://audio/sfx/psyche_voice_lines/death_1.wav"),
	"death_2" : load("res://audio/sfx/psyche_voice_lines/death_2.wav"),
	"death_3" : load("res://audio/sfx/psyche_voice_lines/death_3.wav"),
	"game_over_1" : load("res://audio/sfx/psyche_voice_lines/game_over_1.wav"),
	"game_over_2" : load("res://audio/sfx/psyche_voice_lines/game_over_2.wav"),
	"game_over_3" : load("res://audio/sfx/psyche_voice_lines/game_over_3.wav"),
	"game_over_4" : load("res://audio/sfx/psyche_voice_lines/game_over_4.wav"),
	"laugh_1" : load("res://audio/sfx/psyche_voice_lines/laugh_1.wav"),
	"laugh_2" : load("res://audio/sfx/psyche_voice_lines/laugh_2.wav"),
	"laugh_3" : load("res://audio/sfx/psyche_voice_lines/laugh_3.wav"),
	"laugh_4" : load("res://audio/sfx/psyche_voice_lines/laugh_4.wav"),
	"psyche_1" : load("res://audio/sfx/psyche_voice_lines/psyche_1.wav"),
	"psyche_2" : load("res://audio/sfx/psyche_voice_lines/psyche_2.wav"),
	"salvation_1" : load("res://audio/sfx/psyche_voice_lines/salvation_1.wav"),
	"salvation_2" : load("res://audio/sfx/psyche_voice_lines/salvation_2.wav")
}

var enemy_death_counter : int = 0

var _game_win := false
var _game_lose := false

func _ready() -> void:
	GlobalSignalBus.player_death.connect(_on_player_death)
	GlobalSignalBus.player_respawn.connect(_on_psyche_request_received)
	GlobalSignalBus.psyche_task_request.connect(_on_psyche_request_received)
	GlobalSignalBus.change_goal_count.connect(_on_change_goal_count)
	
	GlobalSignalBus.game_start.connect(_on_game_start)
	GlobalSignalBus.game_over.connect(_on_game_over)
	GlobalSignalBus.game_win.connect(_on_game_win)
	GlobalSignalBus.retry.connect(_on_game_retry)
	
	GlobalSignalBus.enemy_death.connect(_on_enemy_death)
	
	GlobalSignalBus.task_completed.connect(_on_task_completed)
	GlobalCardTimer.timeout.connect(_on_player_death)

func _process(delta : float ) -> void:
	if _game_win:
		animated_sprite_2d.play("death")
	elif _game_lose:
		animated_sprite_2d.play("game_over")

func _play_audio(name : String) -> void:
	audio_player.stream = audio_dict[name]
	audio_player.play()

func _on_game_retry() -> void:
	_game_win = false
	_game_lose = false

func _on_game_start() -> void:
	animated_sprite_2d.play("rest")

func _on_enemy_death(is_golden : bool) -> void:
	enemy_death_counter += 1
	
	if enemy_death_counter > 15:
		animated_sprite_2d.play("really_angry")
	else:
		animated_sprite_2d.play("angry")
	
func _on_task_completed(task_type : int) -> void:
	if task_type == Global.TASK_TYPE.DEFEAT || task_type == Global.TASK_TYPE.DEFEAT_GOLD:
		animated_sprite_2d.play("really_angry")
	else:
		animated_sprite_2d.play("angry")
	
func _on_psyche_request_received() -> void:
	var i : int = randi_range(1, 2)
	var audio_name : String = "psyche_" + str(i)
	
	_play_audio(audio_name)
	animated_sprite_2d.play("talk")			
	
func _on_change_goal_count(inc_amt : int) -> void:
	if inc_amt > 0:
		return
	
	var i : int = randi_range(1, 2)
	var audio_name : String = "salvation_" + str(i)
	
	_play_audio(audio_name)
	animated_sprite_2d.play("talk")		
	
func _on_game_over() -> void:
	var i : int = randi_range(1, 4)
	var audio_name : String = "game_over_" + str(i)
	
	_play_audio(audio_name)
	_game_lose = true

func _on_game_win() -> void:
	var i : int = randi_range(1, 3)
	var audio_name : String = "death_" + str(i)
	
	_play_audio(audio_name)
	_game_win = true

func _on_player_death() -> void:
	var i : int = randi_range(1, 4)
	var audio_name : String = "laugh_" + str(i)
	
	_play_audio(audio_name)
	animated_sprite_2d.play("laugh")
	
func _on_audio_player_finished() -> void:
	animated_sprite_2d.play("rest")
