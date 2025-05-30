extends Sprite2D

@export var sequence : int = 0
@export var min_x : float
@export var max_x : float
@export var speed : float = 20.0
@export var direction = 1

func _process(delta: float) -> void:
	if Global.structure[sequence] == true:
		if modulate.a < 0.01:
			queue_free()
		modulate.a /= 1.01
	
	position.x += speed * delta * direction
	if position.x > max_x:
		direction = -1
	if position.x < min_x:
		direction = 1
