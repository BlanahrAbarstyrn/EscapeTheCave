extends Area2D


const TRIPPED_CONDITION: String = "parameters/conditions/on_tripped"

@onready var cp_sprite_2d: Sprite2D = $CPSprite2D
@onready var cp_animation_tree: AnimationTree = $CPAnimationTree
@onready var level_complete: AudioStreamPlayer2D = $LevelComplete



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalManager.on_boss_dead.connect(on_boss_dead)


func on_boss_dead(_p: int) -> void:
	cp_sprite_2d.show()
	cp_animation_tree[TRIPPED_CONDITION] = true
	monitoring = true
	SoundManager.play_clip(level_complete, SoundManager.SOUND_CHECKPOINT)


func _on_area_entered(_area: Area2D) -> void:
	SoundManager.play_clip(level_complete, SoundManager.SOUND_WIN)
	SignalManager.on_level_complete.emit()
