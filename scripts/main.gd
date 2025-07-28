extends Control


const HIGH_SCORE_LABEL = preload("res://scenes/high_score_label.tscn")


@onready var grid_container_scores: GridContainer = $MarginContainer/GridContainer2/GridContainerScores


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_score()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("jump"):
		GameManager.load_next_level_scene()


func set_score() -> void:
	for c in grid_container_scores.get_children():
		grid_container_scores.remove_child(c)
		
	for s in ScoreManager.get_score_history():
		var lb: Label = HIGH_SCORE_LABEL.instantiate()
		lb.text = "%04d" % s
		grid_container_scores.add_child(lb)
