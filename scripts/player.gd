extends CharacterBody2D

class_name Player

# list of action states the player can be in
enum PlayerAction { IDLE, RUN, JUMP, FALL, HURT }

const PLAYER_OFF_SCREEN: float = 200.0
const GRAVITY: float = 690.0 # exerted on player
const RUN_RATE: float = 120.0 # player run speed
const CLAMPED_FALL_RATE: float = 400.0 # player maximum falling speed
const JUMP_RATE: float = -335.0 # velocity at which the player can jump
const INJURED_LEAP_VELOCITY: Vector2 = Vector2(0, -130.0) # velocity at which player jumps upon being injured


@onready var player_sprite_2d: Sprite2D = $PlayerSprite2D
@onready var debugging: Label = $Debugging
@onready var player_animation: AnimationPlayer = $PlayerAnimation
@onready var caster: Caster = $Caster
@onready var impervious_timer: Timer = $ImperviousTimer
@onready var impervious_player: AnimationPlayer = $ImperviousPlayer
@onready var injured_timer: Timer = $InjuredTimer
@onready var sound_effects: AudioStreamPlayer2D = $SoundEffects
@onready var player_camera: Camera2D = $PlayerCamera



# player's default or initial action will be idle
var _action: PlayerAction = PlayerAction.IDLE
var _impervious: bool = false
var _lives: int = 5


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	call_deferred("delayed_setup")

# needed to keep hearts rendered on screen in line with qty of lives declared
# should they be different than 5
func delayed_setup() -> void:
	SignalManager.on_initiate_level.emit(_lives)


#func set_camera_limit(limit_minimum: Vector2, limit_maximum: Vector2) -> void:
#	player_camera.limit_bottom = limit_minimum.y
#	player_camera.limit_top = limit_maximum.y
#	player_camera.limit_right = limit_maximum.x


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	player_off_screen() # check each cycle that player is still on screen
	# if the character is not on the floor, exert gravity
	# and have it increase in velocity the longer the
	# player falls
	if is_on_floor() == false:
		velocity.y += GRAVITY * delta
	
	get_input()
	move_and_slide()
	determine_actions()
	update_debugging()
	
	if Input.is_action_just_pressed("cast"):
		cast()


func player_off_screen() -> void:
	if global_position.y < PLAYER_OFF_SCREEN:
		return
	lose_life(_lives)

# temporary label on player for debugging purposes <<< remove prior to shipping game
func update_debugging() -> void:
	debugging.text = "floor:%s inv:%s\n%s\n%.0f,%.0f\n%d" % [
		is_on_floor(), _impervious,
		PlayerAction.keys()[_action],
		velocity.x, velocity.y, _lives
	]


func cast() -> void:
	if player_sprite_2d.flip_h:
		caster.cast(Vector2.LEFT)
	else:
		caster.cast(Vector2.RIGHT)


func get_input() -> void:
	if _action == PlayerAction.HURT:
		return
	velocity.x = 0
	if Input.is_action_pressed("left") == true:
		velocity.x = -RUN_RATE
		player_sprite_2d.flip_h = true # sprite offset Flip H On
	elif Input.is_action_pressed("right") == true:
		velocity.x = RUN_RATE
		player_sprite_2d.flip_h = false # sprite offset Flip H Off
	# allow the player to jump only if they are on the floor
	if Input.is_action_just_pressed("jump") == true and is_on_floor() == true:
		velocity.y = JUMP_RATE
		SoundManager.play_clip(sound_effects, SoundManager.SOUND_JUMP)
	# clamp the y velocity between these two preset rates
	velocity.y = clampf(velocity.y, JUMP_RATE, CLAMPED_FALL_RATE)


func determine_actions() -> void:
	if _action == PlayerAction.HURT:
		return
	if is_on_floor() == true:
		if velocity.x == 0:
			set_action(PlayerAction.IDLE) # action is idle
		else:
			set_action(PlayerAction.RUN) # action is running
	else:
		if velocity.y > 0:
			set_action(PlayerAction.FALL) # action is falling
		else:
			set_action(PlayerAction.JUMP) # action is jumping


func set_action(new_action: PlayerAction) -> void:
	if new_action == _action:
		return # no change in action required
	
	if _action == PlayerAction.FALL:
		if new_action == PlayerAction.IDLE or new_action == PlayerAction.RUN:
			SoundManager.play_clip(sound_effects, SoundManager.SOUND_LAND)
	
	_action = new_action
	
	match _action:
		PlayerAction.IDLE:
			player_animation.play("idle")
		PlayerAction.RUN:
			player_animation.play("run")
		PlayerAction.JUMP:
			player_animation.play("jump")
		PlayerAction.FALL:
			player_animation.play("fall")
		PlayerAction.HURT:
			player_injured()


func lose_life(reduction: int) -> bool:
	_lives -= reduction
	SignalManager.on_player_injured.emit(_lives)
	if _lives <= 0:
		SignalManager.on_game_over.emit()
		set_physics_process(false)
		player_animation.stop()
		impervious_player.stop()
		print("PLAYER DIES")
		return false
	return true
	


func set_impervious() -> void:
	_impervious = true
	impervious_player.play("impervious")
	impervious_timer.start()


func player_injured() -> void:
	player_animation.play("hurt")
	velocity = INJURED_LEAP_VELOCITY
	injured_timer.start()


func player_hit() -> void:
	if _impervious == true:
		return # player takes no additional damage
	
	if lose_life(1) == false:
		return
	SoundManager.play_clip(sound_effects, SoundManager.SOUND_DAMAGE)
	set_impervious()
	set_action(PlayerAction.HURT)


func _on_impervious_timer_timeout() -> void:
	_impervious = false
	impervious_player.stop()


func _on_player_hit_box_area_entered(_area: Area2D) -> void:
	player_hit()


func _on_injured_timer_timeout() -> void:
	set_action(PlayerAction.IDLE)
