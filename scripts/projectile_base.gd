extends Area2D

# base code weapon effects will inherit from
class_name Projectile


var _direction: Vector2 = Vector2.RIGHT # default direction
var _projectile_lifespan: float = 5.0 # duration of time allowed on screen
var _projectile_lifetime: float = 0.0 # how much time has been on screen


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += _direction * delta
	check_time(delta)


# if the amount of time on screen exceeds the allowed time, remove
func check_time(delta: float) -> void:
	_projectile_lifetime += delta
	if _projectile_lifetime > _projectile_lifespan:
		queue_free()


func initialize(pos: Vector2, direction: Vector2, speed: float, lifespan: float):
	_direction = direction.normalized() * speed
	_projectile_lifespan = lifespan
	global_position = pos


func _on_area_entered(_area: Area2D) -> void:
	queue_free()
