extends AnimatableBody2D

@export var destination: Marker2D
@export var platform_speed: float = 50.0


var _start: Vector2
var _end: Vector2
var _time_to_move: float = 0.0
var _tween: Tween


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_start = global_position
	_end = destination.global_position
	
	var distance: float = _start.distance_to(_end)
	_time_to_move = distance / platform_speed
	
	set_moving()


func _exit_tree() -> void:
	if _tween:
		_tween.kill()


func set_moving() -> void:
	_tween = get_tree().create_tween()
	_tween.set_loops()
	_tween.tween_property(self, "global_position", _end, _time_to_move)
	_tween.tween_property(self, "global_position", _start, _time_to_move)
