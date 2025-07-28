extends CreatureBase


@onready var detect_floor: RayCast2D = $DetectFloor
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


@export var move_speed: float = 50.0


func _physics_process(delta: float) -> void:
	super._physics_process(delta) # invoked from creature_base
	
	# if the creature isn't on the floor, make it fall
	if is_on_floor() == false:
		velocity.y += _gravity * delta
	else: # creature moves left or right
		if animated_sprite_2d.flip_h == true:
			velocity.x = move_speed
		else:
			velocity.x = -move_speed
	
	move_and_slide()
	
	# if the creature hits a wall or detects a gap in the floor, turn around
	if is_on_floor() == true:
		if is_on_wall() == true or detect_floor.is_colliding() == false:
			flip_animation()


func flip_animation() -> void:
	animated_sprite_2d.flip_h = !animated_sprite_2d.flip_h
	detect_floor.position.x = -detect_floor.position.x
