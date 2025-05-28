extends CharacterBody2D

@export var Speed = 400
@export var scene_to_load = "res://Scenes/Book/book.tscn"

@onready var anim_walk = $Walk



func _process(delta):
	var InputV2 = Vector2.ZERO
	if Input.is_action_pressed("go_up"):
		InputV2.y-=1
	if Input.is_action_pressed("go_down"):
		InputV2.y+=1
	if Input.is_action_pressed("go_left"):
		InputV2.x-=1
	if Input.is_action_pressed("go_right"):
		InputV2.x+=1
	InputV2 = InputV2.normalized() #单位化，防止同时按到速度过快
	InputV2 *= Speed
	position += InputV2 * delta #确保游戏对象在任何帧率下都以恒定速度运行
	
	if InputV2 != Vector2.ZERO:
		move_and_slide()
		play_animation(InputV2)
	else:
		anim_walk.animation = "sit"
		if !anim_walk.is_playing():
			anim_walk.play()
		
		

func play_animation(direction: Vector2):
	if direction.x < 0:
		anim_walk.animation = "walk_left"
	elif direction.x > 0:
		anim_walk.animation = "walk_right" 
	elif direction.y < 0:
		anim_walk.animation = "walk_up"
	elif direction.y > 0:
		anim_walk.animation = "walk_down"
		
	if !anim_walk.is_playing():
		anim_walk.play()


func _on_quit_button_pressed() -> void:
	get_tree().change_scene_to_file(scene_to_load)
