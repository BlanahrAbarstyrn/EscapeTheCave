extends CreatureBase


@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var caster: Caster = $Caster
@onready var detect_player: RayCast2D = $DetectPlayer
@onready var pivot_timer: Timer = $PivotTimer

# setting up for zig zag
const FLY_RATE: Vector2 = Vector2(35, 15)
var _fly_path: Vector2 = Vector2.ZERO # (-1, 1) (1, 1)


func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	velocity =  _fly_path
	move_and_slide()
	cast()


func cast() -> void:
	if detect_player.is_colliding() == true:
		caster.cast(
			global_position.direction_to(
				_hunt_player.global_position
			)
		)



func fly_towards_player() -> void:
	var x_dir = sign(_hunt_player.global_position.x - global_position.x)
	if x_dir > 0:
		animated_sprite_2d.flip_h = true
	else:
		animated_sprite_2d.flip_h = false
	_fly_path = Vector2(x_dir, 1) * FLY_RATE


# zig or zag on timer timeout
func _on_pivot_timer_timeout() -> void:
	fly_towards_player()


func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	animated_sprite_2d.play("fly")
	pivot_timer.start()
	fly_towards_player()
