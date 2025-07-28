extends Area2D


@onready var gems: AnimatedSprite2D = $AnimatedSprite2D
@onready var sound_effects: AudioStreamPlayer2D = $SoundEffects


const GRAVITY: float = 160.0
const LEAP: float = -120.0
const POINTS: int = 2

var _begin_y: float
var _speed_y: float = LEAP


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	_begin_y = position.y # start at current position
	
	# grab all names set up for animation and push to array
	# to then pick from random for loot
	var list_names: Array[String] = []
	for gem in gems.sprite_frames.get_animation_names():
		list_names.push_back(gem)
	gems.animation = list_names.pick_random()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.y += _speed_y * delta # shoot loot upward
	_speed_y += GRAVITY * delta # have loot fall back to ground
	
	if position.y > _begin_y:
		set_process(false) # stop falling once back to original position


func make_gone() -> void:
	hide()
	queue_free()

# make loot disappear on timeout
func _on_gather_timer_timeout() -> void:
	make_gone()


func _on_area_entered(_area: Area2D) -> void:
	SignalManager.on_pickup_collide.emit(POINTS)
	make_gone()
	
