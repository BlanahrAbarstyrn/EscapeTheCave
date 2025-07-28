extends Node2D


const PROJECTILE_SCENES: Dictionary = {
	Globals.ObjectType.PICKUP: preload("res://scenes/creature_loot.tscn"),
	Globals.ObjectType.EXPLOSION: preload("res://scenes/creature_death.tscn"),
	Globals.ObjectType.PROJECTILE_PLAYER: preload("res://scenes/projectile_player.tscn"),
	Globals.ObjectType.PROJECTILE_ENEMY: preload("res://scenes/projectile_enemy.tscn"),
}


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalManager.on_create_projectile.connect(on_create_projectile)
	SignalManager.on_create_object.connect(on_create_object)


func on_create_projectile(pos: Vector2, direction: Vector2,
		projectile_lifespan: float, projectile_speed: float,
		ob_type: Globals.ObjectType) -> void:
	if !PROJECTILE_SCENES.has(ob_type):
		return # if the key doesn't exist, do nothing
	var new_projectile: Projectile = PROJECTILE_SCENES[ob_type].instantiate()
	new_projectile.initialize(pos, direction, projectile_speed, projectile_lifespan)
	call_deferred("add_child", new_projectile)


func on_create_object(pos: Vector2, ob_type: Globals.ObjectType) -> void:
	if !PROJECTILE_SCENES.has(ob_type):
		return # if the key doesn't exist, do nothing
	var new_object = PROJECTILE_SCENES[ob_type].instantiate()
	new_object.position = pos
	call_deferred("add_child", new_object)
