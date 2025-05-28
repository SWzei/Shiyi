extends CharacterBody2D

@export var move_speed : float = 300
@export var acceleration : float = 40
@export var friction : float = 40


@onready var sprite = $Sprite
@onready var camera = $Camera2D
@onready var anim = $AnimationPlayer

func _ready():
	global_position = Global.cur_pos


func _physics_process(delta: float) -> void:
	var input_vector = Input.get_vector("go_left", "go_right", "go_up", "go_down")
	_handle_movement(input_vector, delta)
	_handle_animation()
	
	move_and_slide()

func _handle_movement(input_vector: Vector2, delta: float):
	if input_vector != Vector2.ZERO:
		var target_velocity = input_vector * move_speed
		velocity = velocity.lerp(target_velocity, acceleration * delta)
	else:
		velocity = velocity.lerp(Vector2.ZERO, friction * delta)

func _handle_animation():
	if Input.is_action_pressed("go_left"):
		sprite.flip_h = true
	elif Input.is_action_pressed("go_right"):
		sprite.flip_h = false
	
	if velocity.length() > 10:
		anim.play("move")
	else:
		anim.play("idle")

func change_scenes(path : String):
	Global.cur_pos = global_position
	get_tree().change_scene_to_file(path)
