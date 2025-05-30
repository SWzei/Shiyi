extends Node

@onready var texture_rect = $TextureRect
@onready var timer = $Timer
@onready var tips = $Tips
@onready var label = $Label

#var next_scene : String = "res://Scenes/Main.tscn"
var keyboard_lock : bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.play_music("res://Autio/南望百廿.mp3")
	apply_font_to(label, "res://assets/Fonts/SourceHanSansCN-VF.otf", 48)
	label.visible = false
	tips.modulate.a = 0
	_play_start_tween()
	
	texture_rect.modulate.a = 0.2
	var tween = create_tween()
	tween.tween_property(texture_rect, "modulate:a", 1, 10)
	timer.wait_time = 20
	timer.timeout.connect(_on_timer_timeout)
	timer.start()

func _on_timer_timeout() -> void:
	print("Timer finished, loading new scene")
	keyboard_lock = false
	timer.stop()
	label.visible = true

func _play_start_tween():
	var tween = create_tween()
	tween.tween_property(tips, "modulate:a", 1.0, 4.0)
	tween.tween_interval(4.0)
	tween.tween_property(tips, "modulate:a", 0.0, 0.5)
	tween.tween_callback(func(): 
		tips.visible = false
		tips.modulate.a = 1.0
	)
	
func _input(event):
	if event is InputEventKey and event.pressed and event.keycode == KEY_ENTER:
		if keyboard_lock:
			return
		else:
			_load_new_scene()

func apply_font_to(node: Control, font_path: String, size: int):
	var font_file := load(font_path)
	var font := FontFile.new()
	font.font_data = font_file
	node.add_theme_font_override("font", font)
	node.add_theme_font_size_override("font_size", size)

func _load_new_scene():
	Global.lower_volume(-19, 0.5)
	Global.switch_scene("end_screen")
