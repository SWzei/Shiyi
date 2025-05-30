extends Node2D

@onready var textures := [
	$Texture1,
	$Texture2,
	$Texture3
]

var current_index = 0
var fade_duration = 1.0
var display_time = 2.0
var fade_speed = 1.0 / fade_duration

var is_fading = false
var fade_timer = 0.0

func _ready():
	Global.play_music("res://Autio/PianoPanda - Flower Dance（钢琴版I）.mp3")
	for i in textures.size():
		textures[i].modulate.a = 1.0 if i == 0 else 0.0
	await get_tree().create_timer(display_time).timeout
	_start_next_fade()

func _start_next_fade():
	if current_index + 1 >= textures.size():
		# 所有图片播放完，跳转主场景
		await get_tree().create_timer(1.0).timeout
		get_tree().change_scene_to_file("res://Scenes/Suzhe_scenes/suzhe.tscn")
		return

	fade_timer = 0.0
	is_fading = true

func _process(delta):
	if not is_fading:
		return

	fade_timer += delta
	var alpha = min(fade_timer * fade_speed, 1.0)

	var current_tex = textures[current_index]
	var next_tex = textures[current_index + 1]

	current_tex.modulate.a = 1.0 - alpha
	next_tex.modulate.a = alpha

	if alpha >= 1.0:
		is_fading = false
		current_index += 1
		call_deferred("_wait_before_next_fade")

func _wait_before_next_fade():
	await get_tree().create_timer(display_time).timeout
	_start_next_fade()
