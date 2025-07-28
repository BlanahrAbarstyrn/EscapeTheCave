extends Node

signal on_create_projectile(
	position: Vector2,
	direction: Vector2,
	projectile_lifespan: float,
	projectile_speed: float,
	ob_type: Globals.ObjectType
)

signal on_create_object(
	pos: Vector2,
	ob_type: Globals.ObjectType
)


signal on_pickup_collide(points: int)
signal on_enemy_hit(creature_points: int)
signal on_boss_dead(boss_points: int)
signal on_score_updated(score: int)
signal on_game_over
signal on_player_injured(lives: int)
signal on_initiate_level(lives: int)
signal on_level_complete

signal on_trigger_entered
