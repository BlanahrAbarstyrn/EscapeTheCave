extends Camera2D


@export var jiggle_force: float = 5

@onready var jiggle_timer: Timer = $JiggleTimer



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_process(false)
	SignalManager.on_player_injured.connect(on_player_injured)
	SignalManager.on_game_over.connect(on_game_over)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	offset = get_random_offset()

# create camera jiggle
func get_random_offset() -> Vector2:
	return Vector2(
		randf_range(-jiggle_force, jiggle_force),
		randf_range(-jiggle_force, jiggle_force)
	)


func reset_camera() -> void:
	set_process(false)
	offset = Vector2.ZERO # set camera back to center position

func on_game_over() -> void:
	reset_camera()


func on_player_injured(_lives: int) -> void:
	set_process(true)
	jiggle_timer.start()


func _on_jiggle_timer_timeout() -> void:
	reset_camera()
