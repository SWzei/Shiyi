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
@onready var bgm = $school_song
@onready var bgd = $background

var school_song : AudioStream = preload("res://Autio/南京大学合唱团 - 南京大学校歌.mp3")
var piano_piece : AudioStream = preload("res://Autio/Classical Artists - Etudes, Op_ 10_ No_ 3 in E Major.mp3")

func _ready():
	bgd.modulate.a = 0.7
	
func _exit_tree():
	bgm.stop()

func _on_play_button_pressed() -> void:
	bgm.stop()
	bgm.stream = school_song
	bgm.play()

func _on_play_button_2_pressed() -> void:
	bgm.stop()
	bgm.stream = piano_piece
	bgm.play()


func _on_stop_button_pressed() -> void:
	bgm.stop()

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


func _on_quit_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Suzhe_scenes/photo_show.tscn")
