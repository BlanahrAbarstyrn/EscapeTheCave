extends Node2D


const TRIGGER_CONDITION: String = "parameters/conditions/on_trigger"

@export var boss_lives: int = 1
@export var boss_points: int = 5



@onready var boss_animation_tree: AnimationTree = $BossAnimationTree
@onready var state_machine: AnimationNodeStateMachinePlayback = $BossAnimationTree["parameters/playback"]
@onready var visual: Node2D = $Visual
@onready var boss_hit_box: Area2D = $Visual/BossHitBox


var _boss_impervious: bool = false


func boss_lives_lost() -> void:
	boss_lives -= 1
	if boss_lives <= 0:
		SignalManager.on_boss_dead.emit(boss_points)
		queue_free()


func tween_hit() -> void:
	var tween = create_tween()
	tween.tween_property(visual, "position", Vector2.ZERO, 1.6)


func set_impervious(imperv: bool) -> void:
	_boss_impervious = imperv
	if imperv == true:
		state_machine.travel("hit")


func boss_damage() -> void:
	if _boss_impervious == true:
		return
	
	set_impervious(true)
	tween_hit()
	boss_lives_lost()


func _on_boss_trigger_area_entered(_area: Area2D) -> void:
	boss_animation_tree[TRIGGER_CONDITION] = true
	boss_hit_box.monitoring = true


func _on_boss_hit_box_area_entered(_area: Area2D) -> void:
	boss_damage()
