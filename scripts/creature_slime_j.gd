extends CreatureBase

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var leap_timer: Timer = $LeapTimer

# sets up creature movement
const LEAP_VELOCITY_X = 100
const LEAP_VELOCITY_Y = 250
const LEAP_VELOCITY_R: Vector2 = Vector2(LEAP_VELOCITY_X, -LEAP_VELOCITY_Y)
const LEAP_VELOCITY_L: Vector2 = Vector2(-LEAP_VELOCITY_X, -LEAP_VELOCITY_Y)

# ranges for timer
const MIN_TIME: float = 2.0
const MAX_TIME: float = 5.0

# sets up creature state
var _leap: bool = false
var _player_on_screen: bool = false


func _physics_process(delta: float) -> void:
	super._physics_process(delta) # invoked from creature base
	
	# have creature fall to floor if not already there
	if is_on_floor() == false:
		velocity.y += _gravity * delta
	else: # creature on floor, animate idle state
		velocity.x = 0
		animated_sprite_2d.play("idle")
	
	apply_leap()
	move_and_slide()
	face_player()


# turn the creature to face the player based on player position
func face_player() -> void:
	if(_hunt_player.global_position.x > global_position.x and 
		animated_sprite_2d.flip_h == false):
			animated_sprite_2d.flip_h = true
	elif(_hunt_player.global_position.x < global_position.x and 
		animated_sprite_2d.flip_h == true):
			animated_sprite_2d.flip_h = false


func apply_leap() -> void:
	if is_on_floor() == false:
		return # if slime is midair, do nothing
	
	if _player_on_screen == false or _leap == false:
		return # if slime has not detected player or is not leaping, do nothing
	
	# determine which way the sprite needs to face based on player location
	if animated_sprite_2d.flip_h == false:
		velocity = LEAP_VELOCITY_L
	else:
		velocity = LEAP_VELOCITY_R
	
	_leap = false
	animated_sprite_2d.play("leap")
	launch_timer() # reset cool down after leap
	

# set timer with random wait time
func launch_timer() -> void:
	leap_timer.wait_time = randf_range(MIN_TIME, MAX_TIME)
	leap_timer.start()


func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	_player_on_screen = true
	launch_timer() # reset cool down after player detected


# when timer runs out, allow creature to leap
func _on_leap_timer_timeout() -> void:
	_leap = true
