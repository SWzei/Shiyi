extends Node2D

@onready var do = $do
@onready var re = $re
@onready var mi = $mi
@onready var fa = $fa
@onready var so = $so
@onready var la = $la
@onready var si = $si
@onready var do_1 = $"do'"
@onready var re_1 = $"re'"
@onready var mi_1 = $"mi'"
@onready var fa_1 = $"fa'"
@onready var so_1 = $"so'"
@onready var la_1 = $"la'"
@onready var si_1 = $"si'"

@onready var bgd = $background

func _ready():
	bgd.modulate.a = 0.7    # 设置透明度为 70%


func _process(delta):
	if Input.is_action_just_pressed("play_note_c"):
		do.key_pressed()
	elif Input.is_action_just_released("play_note_c"):
		do.key_released()
	if Input.is_action_just_pressed("play_note_d"):
		re.key_pressed()
	elif Input.is_action_just_released("play_note_d"):
		re.key_released()
	if Input.is_action_just_pressed("play_note_e"):
		mi.key_pressed()
	elif Input.is_action_just_released("play_note_e"):
		mi.key_released()
	if Input.is_action_just_pressed("play_note_f"):
		fa.key_pressed()
	elif Input.is_action_just_released("play_note_f"):
		fa.key_released()
	if Input.is_action_just_pressed("play_note_g"):
		so.key_pressed()
	elif Input.is_action_just_released("play_note_g"):
		so.key_released()
	if Input.is_action_just_pressed("play_note_a"):
		la.key_pressed()
	elif Input.is_action_just_released("play_note_a"):
		la.key_released()
	if Input.is_action_just_pressed("play_note_b"):
		si.key_pressed()
	elif Input.is_action_just_released("play_note_b"):
		si.key_released()
	if Input.is_action_just_pressed("play_note_c'"):
		do_1.key_pressed()
	elif Input.is_action_just_released("play_note_c'"):
		do_1.key_released()
	if Input.is_action_just_pressed("play_note_d'"):
		re_1.key_pressed()
	elif Input.is_action_just_released("play_note_d'"):
		re_1.key_released()
	if Input.is_action_just_pressed("play_note_e'"):
		mi_1.key_pressed()
	elif Input.is_action_just_released("play_note_e'"):
		mi_1.key_released()
	if Input.is_action_just_pressed("play_note_f'"):
		fa_1.key_pressed()
	elif Input.is_action_just_released("play_note_f'"):
		fa_1.key_released()
	if Input.is_action_just_pressed("play_note_g'"):
		so_1.key_pressed()
	elif Input.is_action_just_released("play_note_g'"):
		so_1.key_released()
	if Input.is_action_just_pressed("play_note_a'"):
		la_1.key_pressed()
	elif Input.is_action_just_released("play_note_a'"):
		la_1.key_released()
	if Input.is_action_just_pressed("play_note_b'"):
		si_1.key_pressed()
	elif Input.is_action_just_released("play_note_b'"):
		si_1.key_released()


func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Suzhe_scenes/suzhe.tscn")
