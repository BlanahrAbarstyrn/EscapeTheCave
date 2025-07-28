extends ParallaxBackground


const BG_FILES: Dictionary = {
	1: [
		preload("res://assets/background_level_1/cave-layer-1.png"),
		preload("res://assets/background_level_1/cave-layer-2.png"),
		preload("res://assets/background_level_1/cave-layer-3.png"),
		preload("res://assets/background_level_1/cave-layer-4.png")
	],
	2: [
		preload("res://assets/background_level_1/cave-layer-1.png"),
		preload("res://assets/background_level_1/cave-layer-2.png"),
		preload("res://assets/background_level_1/cave-layer-3.png"),
		preload("res://assets/background_level_1/cave-layer-4.png")
	],
	3: [
		preload("res://assets/background_level_1/cave-layer-1.png"),
		preload("res://assets/background_level_1/cave-layer-2.png"),
		preload("res://assets/background_level_1/cave-layer-3.png"),
		preload("res://assets/background_level_1/cave-layer-4.png")
	],
	4: [
		preload("res://assets/background_level_1/cave-layer-1.png"),
		preload("res://assets/background_level_1/cave-layer-2.png"),
		preload("res://assets/background_level_1/cave-layer-3.png"),
		preload("res://assets/background_level_1/cave-layer-4.png")
	]
}

@export_range(1, 4) var level_number: int = 1


var mirror_x: float = 640.0
var mirror_y: float = 360.0
var sprite_scale: Vector2 = Vector2(1.0, 1.0)


# Called when the node enters the scene tree for the first time.
func _ready():
	add_backgrounds()


func get_increment() -> float:
	return 1.0 / BG_FILES[level_number].size()


func get_sprite(t: Texture2D) -> Sprite2D:
	var sprite = Sprite2D.new()
	sprite.texture = t
	sprite.scale = sprite_scale
	return sprite
	

func add_layer(t: Texture2D, time_offset: float) -> void:
	var sprite = get_sprite(t)
	
	var par_la = ParallaxLayer.new()
	par_la.motion_mirroring = Vector2(mirror_x, mirror_y)
	par_la.motion_scale = Vector2(time_offset, 0)
	par_la.add_child(sprite)
	
	add_child(par_la)


func add_backgrounds() -> void:
	var inc = get_increment()
	var time_offset = inc
	var files_list = BG_FILES[level_number]
	
	for index in range(files_list.size()):
		var bg_file = files_list[index]
		if index == 0:
			add_layer(bg_file, 1)
		else:
			add_layer(bg_file, time_offset)
			time_offset += inc
