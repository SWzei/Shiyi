extends Node

#var next_scene : String = "res://Scenes/Main.tscn"

@onready var texture_rect = $TextureRect
@onready var mono = $PanelContainer/MarginContainer/Monologue

var monologue : String = "         伴随着轻快的音乐，你的记忆又一次回到了从前：大礼堂里曾有过那么多精彩的活动：名家讲座、团日活动、新新节、交响音乐会......一次又一次丰富了我们的课外生活，让我们的大学生活精彩纷呈。\n按Enter以继续……"
var current_index = 0
var typing_speed : float = 8
var keyboard_lock : bool = true

func _ready():
	Global.play_music("res://Autio/Summer Day2.mp3")
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
