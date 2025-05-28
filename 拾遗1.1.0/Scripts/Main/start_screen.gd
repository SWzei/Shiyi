extends Control

@onready var text1 = $text1
@onready var text2 = $text2
@onready var text3 = $text3

func _ready():
	text1.modulate.a = 0
	text2.modulate.a = 0
	text3.modulate.a = 0
	_manage_tween()

func _manage_tween():
	var tween = create_tween()
	tween.tween_property(text1, "modulate:a", 1.0, 2.0)
	tween.tween_property(text2, "modulate:a", 1.0, 2.0)
	tween.tween_property(text3, "modulate:a", 1.0, 2.0)
	tween.finished.connect(_change_scenes)

func _change_scenes():
	get_tree().change_scene_to_file("res://Scenes/Main/main.tscn")
