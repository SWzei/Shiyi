extends Node

#@export var scene_to_load : PackedScene

@onready var texture_rect = $TextureRect
@onready var timer = $Timer
@onready var mono = $PanelContainer/MarginContainer/Monologue

var textures : Array[Texture2D] = []
var monologue : String = "         答题过程中，你想起来了，在你刚刚进入这个校园的时候，你便和新生们一起，随着老师参观了校史馆。你凝视过顾毓琇先生题写的馆名，聆听过李叔同、江谦先生谱著的庄严的校歌，回顾过南京大学走过的百年校史，也曾立志要成为像程开甲等那样投身为国的\"大先生\"......
							Enter键以继续......"
var current_index = 0
var typing_speed : float = 8
var keyboard_lock : bool = true

func _ready():
	Global.play_music("res://Autio/oskarpianist - One Summer's Day (钢琴班).ogg")
	textures = [
		preload("res://Sprites/Structures/SchoolHistoryMuseum/SchoolHistoryMuseum.jpg"),
#		preload("res://Sprites/Structures/SHM1.jpg"),
		preload("res://Sprites/Structures/SchoolHistoryMuseum/SHM3.jpg"),
#		preload("res://Sprites/Structures/SHM2.jpg"),
		preload("res://Sprites/Structures/SchoolHistoryMuseum/SHM4.jpg"),
		preload("res://Sprites/Structures/SchoolHistoryMuseum/SHM5.jpg"),
#		preload("res://Sprites/Structures/SHM6.jpg"),
		preload("res://Sprites/Structures/SchoolHistoryMuseum/SHM7.jpg"),
#		preload("res://Sprites/Structures/SHM8.jpg"),
	]
	texture_rect.texture = textures[0]
	texture_rect.modulate.a = 1.0
	timer.timeout.connect(_on_timer_timeout)
	timer.wait_time = 8.0
	timer.start()
	apply_font_to(mono, "res://assets/Fonts/SourceHanSansCN-VF.otf", 56)
	typewriter_show(monologue)

func _on_timer_timeout():
	timer.stop()
	timer.wait_time = 3.5
	timer.start()
	var tween = create_tween()
	tween.tween_property(texture_rect, "modulate:a", 0.2, 0.8)
	tween.tween_callback(Callable(self, "_on_fade_out_finished"))

func _on_fade_out_finished():
	current_index = (current_index + 1) % textures.size()
	texture_rect.texture = textures[current_index]
	var tween = create_tween()
	tween.tween_property(texture_rect, "modulate:a", 1.0, 0.8)

func apply_font_to(node: Control, font_path: String, size: int):
	var font_file := load(font_path)
	var font := FontFile.new()
	font.font_data = font_file
	node.add_theme_font_override("font", font)
	node.add_theme_font_size_override("font_size", size)

func typewriter_show(text: String) -> void:
	var typing_time := 0.0
	mono.text = text
	mono.visible_characters = 0

	while mono.visible_characters < text.length():
		typing_time += get_process_delta_time()
		mono.visible_characters = int(typing_speed * typing_time)
		await get_tree().process_frame
	
	keyboard_lock = false
	
func _input(event):
	if event is InputEventKey and event.pressed and event.keycode == KEY_ENTER:
		if keyboard_lock:
			return
		else:
			$Timer.stop()
			_load_new_scene()

func _load_new_scene():
	Global.switch_scene("book")
