extends CharacterBody2D

signal OnUpdateHealth(health : int)
signal OnUpdateScore(score : int)
signal OnHealHealth(health : int)

#Properties
@export var move_speed : float = 100
@export var acceleration : float = 50
@export var braking : float = 50
@export var gravity : float = 500
@export var jump_force : float = 240

@export var health : int = 3
@export var falling_dist : int = 200

var start_pos : Vector2
var move_input : float

#CanvasLayer
@onready var HeartNum : Label = $CanvasLayer/HeartsNum
@onready var sprite : Sprite2D = $Sprite
@onready var anim1 : AnimationPlayer = $AnimationPlayer1
@onready var anim2 : AnimationPlayer = $AnimationPlayer2
@onready var anim : AnimationPlayer
@onready var audio : AudioStreamPlayer = $AudioStreamPlayer
@onready var control_text : Label = $CanvasLayer/ControlOrder

var take_damage_sfx : AudioStream = preload("res://Autio/OrienteeringAudio/take_damage.mp3")
var coin_sfx : AudioStream = preload("res://Autio/OrienteeringAudio/coin.mp3")

func _ready():
	if PlayerStats.player_skin == 1:
		anim = anim1
	if PlayerStats.player_skin == 2:
		anim = anim2
	
	start_pos = global_position
	
	$"../ControlFlags/ControlFlag".judge.connect(_judge_order)
	$"../ControlFlags/ControlFlag2".judge.connect(_judge_order)
	$"../ControlFlags/ControlFlag3".judge.connect(_judge_order)
	$"../ControlFlags/ControlFlag4".judge.connect(_judge_order)
	
	await get_tree().create_timer(0.1).timeout
	$"../Signboard".enter.connect(_enter)
	$"../Signboard2".enter.connect(_enter)
	$"../Endboard".enter.connect(_enter)

func _physics_process(delta):
	#gravity
	if not is_on_floor():
		velocity.y += gravity * delta
	
	#get the move input
	move_input = Input.get_axis("move_left", "move_right")
	
	#movement
	if move_input != 0:
		velocity.x = lerp(velocity.x, move_input * move_speed, acceleration * delta)
	else:
		velocity.x = lerp(velocity.x, 0.0, braking * delta)
	
	#jumping
	if Input.is_action_pressed("jump") and is_on_floor():
		velocity.y = -jump_force
	
	move_and_slide()

func _process(delta):
	if velocity.x != 0:
		sprite.flip_h = velocity.x < 0
	
	if global_position.y >= falling_dist:
		global_position = start_pos 
		take_damage(1)
	
	_manage_animation()

func set_start_pos(pos : Vector2):
	start_pos = pos

func _manage_animation():
	if not is_on_floor():
		anim.play("jump")
	elif move_input != 0:
		anim.play("move")
	else:
		anim.play("idle")

func _judge_order(sequence : int):
	var locked = false
	for i in sequence:
		if PlayerStats.controller_unlockd[i] == false:
			locked = true
	if locked == true:
		control_text.visible = true
		control_text.text = str(PlayerStats.controller_number[sequence]) + "号点位已打卡"
		PlayerStats.controller_unlockd.fill(false)
		await get_tree().create_timer(1.5).timeout
		control_text.visible = false
	else:
		PlayerStats.controller_unlockd[sequence] = true
		await get_tree().create_timer(0.5).timeout
		control_text.visible = true
		control_text.text = str(PlayerStats.controller_number[sequence]) + "号点位已打卡"
		await get_tree().create_timer(1.5).timeout
		control_text.visible = false
		if PlayerStats.controller_unlockd[3] == true:
			await get_tree().create_timer(0.5).timeout
			control_text.visible = true
			control_text.text = "全部点位打卡完成！"
			await get_tree().create_timer(1.5).timeout
			control_text.visible = false

func _enter(text : String):
	control_text.visible = true
	control_text.text = text
	await get_tree().create_timer(1.5).timeout
	control_text.visible = false


func take_damage(amount : int):
	health -= amount
	OnUpdateHealth.emit(health)
	_damage_flash()
	play_sound(take_damage_sfx)
	
	if (health <= 0):
		call_deferred("_reload_the_scene")
		#HeartNum.visible = true
		#global_position = start_pos 
		#HeartNum.text = "×  " + str(health)
	#else:
		#HeartNum.visible = false
func _reload_the_scene():
	get_tree().reload_current_scene()


func take_heal(amount : int):
	health += amount
	if health > PlayerStats.max_health:
		health = PlayerStats.max_health
	OnHealHealth.emit(health)
	
	if (health <= 0):
		HeartNum.visible = true
		HeartNum.text = "×  " + str(health)
	else:
		HeartNum.visible = false

#func game_over():
	#get_tree().change_scene_to_file("res://Scenes/menu.tscn")

func increase_score(amount : int):
	PlayerStats.coin_count += amount
	OnUpdateScore.emit(PlayerStats.coin_count)
	play_sound(coin_sfx)

func _damage_flash ():
	sprite.modulate = Color.RED
	await get_tree().create_timer(0.1).timeout
	sprite.modulate = Color.WHITE

func play_sound (sound : AudioStream):
	audio.stream = sound
	audio.play()
