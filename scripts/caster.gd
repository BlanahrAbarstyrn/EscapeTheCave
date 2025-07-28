extends Node2D


class_name Caster


@onready var cast_timer: Timer = $CastTimer
@onready var cast_sound: AudioStreamPlayer2D = $CastSound


@export var speed: float = 50.0
@export var life_span: float = 10.0
@export var projectile_key: Globals.ObjectType
@export var cast_delay: float = 0.7


var _can_cast: bool = true


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	cast_timer.wait_time = cast_delay


func cast(direction: Vector2) -> void:
	if _can_cast == false:
		return # not enough time has elapsed between casts - do nothing
	
	_can_cast = false
	
	SignalManager.on_create_projectile.emit(
		global_position,
		direction,
		life_span,
		speed,
		projectile_key
	)
	
	cast_timer.start()
	SoundManager.play_clip(cast_sound, SoundManager.SOUND_LASER)


func _on_cast_timer_timeout() -> void:
	_can_cast = true
