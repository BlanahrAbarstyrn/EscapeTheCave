extends Node2D

@export var camera_max: Vector2
@export var camera_min: Vector2

@onready var player: Player = $Player


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalManager.on_game_over.connect(on_game_over)
	SignalManager.on_level_complete.connect(on_game_over)
	#player.set_camera_limit(camera_min, camera_max)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("advance"):
		GameManager.load_next_level_scene()
	if Input.is_action_just_pressed("quit"):
		GameManager.load_main_scene()


func on_game_over() -> void:
	for member in get_tree().get_nodes_in_group(Globals.MOVING_GROUP):
		member.set_process(false)
		member.set_physics_process(false)
