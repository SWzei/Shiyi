extends Node2D

@export var move_direction : Vector2 = Vector2(100, 0)
@export var move_speed : float = 10

@onready var sprite = $Sprite

@onready var start_pos : Vector2 = global_position
@onready var target_pos : Vector2 = start_pos + move_direction

var float_speed : float = 5.0
var float_range : float = 3.0
var float_time : float = 0.0

func _physics_process(delta):
	global_position = global_position.move_toward(target_pos, move_speed * delta)
	
	if global_position == target_pos:
		sprite.flip_h = !sprite.flip_h
		if target_pos == start_pos:
			target_pos = start_pos + move_direction
		else:
			target_pos = start_pos
	
	float_time += delta
	var vertical_offset = sin(float_time * float_speed) * float_range
	sprite.offset.y = vertical_offset
