extends Control


@onready var score_label: Label = $MarginContainer/HBoxScore/ScoreLabel
@onready var h_box_hearts: HBoxContainer = $MarginContainer/HBoxScore/HBoxHearts
@onready var color_rect: ColorRect = $ColorRect
@onready var v_box_level_complete: VBoxContainer = $ColorRect/VBoxLevelComplete
@onready var v_box_game_over: VBoxContainer = $ColorRect/VBoxGameOver
@onready var hud_sound: AudioStreamPlayer2D = $HUDSound
@onready var continue_timer: Timer = $ContinueTimer


var _heart_lives: Array
var _can_continue: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	on_score_updated(ScoreManager.get_score())
	_heart_lives = h_box_hearts.get_children()
	SignalManager.on_player_injured.connect(on_player_injured)
	SignalManager.on_initiate_level.connect(on_player_injured)
	SignalManager.on_game_over.connect(on_game_over)
	SignalManager.on_score_updated.connect(on_score_updated)
	SignalManager.on_level_complete.connect(on_level_complete)


func _process(_delta: float) -> void:
	if _can_continue and Input.is_action_just_pressed("jump"):
		if v_box_game_over.visible == true:
			GameManager.load_main_scene()
		else:
			GameManager.load_next_level_scene()



func on_score_updated(score: int) -> void:
	score_label.text = "%05d" % score


func on_player_injured(lives: int) -> void:
	for life in range(_heart_lives.size()):
		_heart_lives[life].visible = lives > life


func reveal_hud() -> void:
	color_rect.show()
	continue_timer.start()


func on_game_over() -> void:
	hud_sound.play()
	reveal_hud()
	v_box_game_over.show()


func on_level_complete() -> void:
	reveal_hud()
	v_box_level_complete.show()


func _on_continue_timer_timeout() -> void:
	_can_continue = true
