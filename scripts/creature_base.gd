extends CharacterBody2D

# base code all other standard creatures will inherit from
class_name CreatureBase


const DELETE_LEAVE_SCREEN: float = 200.0


@export var creature_points: int = 1


var _hunt_player: Player # for creatures that track player
var _gravity: float = 800.0
var _dead: bool = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_hunt_player = get_tree().get_first_node_in_group(
		Globals.PLAYER_GROUP
	)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	off_screen()

# delete any creatures that fall off the screen
func off_screen() -> void:
	if global_position.y > DELETE_LEAVE_SCREEN:
		queue_free()


func creature_die():
	# protect against dead being called more than once
	if _dead == true:
		return
	
	_dead = true
	
	set_physics_process(false)
	hide()
	
	SignalManager.on_enemy_hit.emit(creature_points)
	
	SignalManager.on_create_object.emit(
		global_position,
		Globals.ObjectType.EXPLOSION
	)
	SignalManager.on_create_object.emit(
		global_position,
		Globals.ObjectType.PICKUP
	)
	
	queue_free()


func _on_creature_hit_box_area_entered(_area: Area2D) -> void:
	creature_die()

# to be overwritten by creatures that track the player
func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	pass # Replace with function body.
