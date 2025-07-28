
extends Node


const SOUND_LASER = "laser"
const SOUND_CHECKPOINT = "checkpoint"
const SOUND_DAMAGE = "damage"
const SOUND_KILL = "kill"
const SOUND_GAMEOVER = "gameover1"
const SOUND_IMPACT = "impact"
const SOUND_LAND = "land"
const SOUND_MUSIC1 = "music1"
const SOUND_MUSIC2 = "music2"
const SOUND_PICKUP = "pickup"
const SOUND_BOSS_ARRIVE = "boss_arrive"
const SOUND_JUMP = "jump"
const SOUND_WIN = "win"


var SOUNDS: Dictionary = {
	SOUND_CHECKPOINT: preload("res://assets/sound/checkpoint.wav"),
	SOUND_DAMAGE: preload("res://assets/sound/damage.wav"),
	SOUND_KILL: preload("res://assets/sound/pickup5.ogg"),
	SOUND_GAMEOVER: preload("res://assets/sound/game_over.ogg"),
	SOUND_IMPACT: preload("res://assets/sound/impact.wav"),
	SOUND_JUMP: preload("res://assets/sound/jump.wav"),
	SOUND_LAND: preload("res://assets/sound/land.wav"),
	SOUND_LASER: preload("res://assets/sound/laser.wav"),
	SOUND_MUSIC1: preload("res://assets/sound/Farm Frolics.ogg"),
	SOUND_MUSIC2: preload("res://assets/sound/Flowing Rocks.ogg"),
	SOUND_PICKUP: preload("res://assets/sound/pickup5.ogg"),
	SOUND_BOSS_ARRIVE: preload("res://assets/sound/boss_arrive.wav"),
	SOUND_WIN: preload("res://assets/sound/you_win.ogg")
}


func play_clip(player: AudioStreamPlayer2D, clip_key: String) -> void:
	if SOUNDS.has(clip_key) == false:
		return
	player.stream = SOUNDS[clip_key]
	player.play()
