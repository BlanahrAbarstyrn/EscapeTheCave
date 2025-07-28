extends Node


const SAVE_SCORE_DATA: String = "user://EscapeTheCave.json"
const MAX_SCORES = 10


var _score: int = 0
var _history: Array = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalManager.on_enemy_hit.connect(update_score)
	SignalManager.on_pickup_collide.connect(update_score)
	SignalManager.on_boss_dead.connect(update_score)
	SignalManager.on_game_over.connect(on_game_over)
	load_history()


func get_score_history() -> Array[int]:
	var h: Array[int] = []
	for s in _history.slice(0, MAX_SCORES):
		if s.score != 0:
			h.push_back(int(s.score))
	return h


func update_score(points: int) -> void:
	_score += points
	SignalManager.on_score_updated.emit(_score)


func on_game_over():
	_history.append({"score": _score})
	save_scores()


func reset_score():
	_score = 0


func get_score() -> int:
	return _score


func save_scores():
	_history.sort_custom(compare_scores)
	var file = FileAccess.open(SAVE_SCORE_DATA, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(_history.slice(0, MAX_SCORES)))
		file.close()


func load_history():
	_history.clear()
	var file = FileAccess.open(SAVE_SCORE_DATA, FileAccess.READ)
	if file:
		var text: String = file.get_as_text()
		if text and text.length() > 0:
			_history = JSON.parse_string(file.get_as_text())
		file.close()
	else:
		save_scores()
	_history.sort_custom(compare_scores)
	print(_history)


func compare_scores(a, b):
	return b.score < a.score
