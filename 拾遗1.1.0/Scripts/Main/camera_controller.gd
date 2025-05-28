extends Camera2D

@export var move_speed : float = 50.0
@export var zoom_amount : float = 0.2

#@onready var shot = $Papershot
#var min_pos = Vector2(-180, -120)
#var max_pos = Vector2(180, 120)

func _process(delta):
	if Global.camera_on == true:
		_move(delta)
		_zoom(delta)

func _move(delta):
	var input = Input.get_vector("cam_left", "cam_right", "cam_up", "cam_down")
	var zoom_mod = 9.0 - zoom.x
	global_position += input * delta * move_speed * zoom_mod
	
	#global_position.x = clamp(global_position.x, min_pos.x, max_pos.x)
	#global_position.y = clamp(global_position.y, min_pos.y, max_pos.y)

func _zoom(_delta):
	var z = zoom.x
	
	if Input.is_action_just_released("cam_zoom_in"):
		z += zoom_amount
	if Input.is_action_just_released("cam_zoom_out"):
		z -= zoom_amount
	
	z = clamp(z, 0.5, 8.0)
	zoom.x = z
	zoom.y = z
