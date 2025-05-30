extends Node

#var next_scene : String = "res://Scenes/Main.tscn"

@onready var texture_rect = $TextureRect
@onready var mono = $PanelContainer/MarginContainer/Monologue

var monologue : String = "          看着照片里的阿苏，忽地，你想起，每次你带家人、朋友来到此地之时，总会留下一张合照。这里是北大楼，人们在楼前的草坪前打卡拍照，殊不知，他们本身，已经成为这里的美好风景的一部分了。\n          它，承载着历史而来，与当代的人们相拥，最终，一同成为时代的一张剪影。\n按Enter键继续……"
var current_index = 0
var typing_speed : float = 8
var keyboard_lock : bool = true

func _ready():
	Global.play_music("res://Autio/oskarpianist - One Summer's Day (钢琴班).ogg")
	apply_font_to(mono, "res://assets/Fonts/SourceHanSansCN-VF.otf", 56)
	typewriter_show(monologue)
	var tween = create_tween()
	tween.tween_property(texture_rect, "modulate:a", 0.8, 12)
	

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
			_load_new_scene()

func _load_new_scene():
	Global.switch_scene("book")
