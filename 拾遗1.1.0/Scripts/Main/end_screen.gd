extends Control

@onready var page1 = $Page1
@onready var page2 = $Page2
@onready var page3 = $Page3

@onready var text1 = $Page1/text1
@onready var text2 = $Page1/text2
@onready var text3 = $Page1/text3
@onready var text4 = $Page1/text4
@onready var text5 = $Page1/text5
@onready var text6 = $Page1/text6
@onready var text7 = $Page1/text7

@onready var text8 = $Page2/text8
@onready var text9 = $Page2/text9
@onready var text10 = $Page2/text10

@onready var text11 = $Page3/text11
@onready var text12 = $Page3/text12

@onready var mapbutton = $MapButton
@onready var bookbutton = $BookButton
@onready var quitbutton = $QuitButton

func _ready():
	text1.modulate.a = 0
	text2.modulate.a = 0
	text3.modulate.a = 0
	text4.modulate.a = 0
	text5.modulate.a = 0
	text6.modulate.a = 0
	text7.modulate.a = 0
	text8.modulate.a = 0
	text9.modulate.a = 0
	text10.modulate.a = 0
	text11.modulate.a = 0
	text12.modulate.a = 0
	_play_tween1()

func _play_tween1():
	var tween = create_tween()
	tween.tween_property(text1, "modulate:a", 1.0, 2.5)
	tween.tween_property(text2, "modulate:a", 1.0, 2.5)
	tween.tween_property(text3, "modulate:a", 1.0, 2.5)
	tween.tween_property(text4, "modulate:a", 1.0, 4.0)
	tween.tween_property(text5, "modulate:a", 1.0, 3.0)
	tween.tween_property(text6, "modulate:a", 1.0, 5.0)
	tween.tween_property(text7, "modulate:a", 1.0, 4.0)
	tween.finished.connect(_play_tween2)

func _play_tween2():
	page1.visible = false
	page2.visible = true
	var tween = create_tween()
	tween.tween_property(text8, "modulate:a", 1.0, 5.0)
	tween.tween_property(text9, "modulate:a", 1.0, 4.0)
	tween.tween_property(text10, "modulate:a", 1.0, 6.0)
	tween.finished.connect(_play_tween3)

func _play_tween3():
	page2.visible = false
	page3.visible = true
	var tween = create_tween()
	tween.tween_property(text11, "modulate:a", 1.0, 2.0)
	tween.tween_property(text12, "modulate:a", 1.0, 4.0)
	tween.finished.connect(_end)

func _end():
	mapbutton.visible = true
	bookbutton.visible = true
	quitbutton.visible = true

func _on_map_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Main/main.tscn")

func _on_book_button_pressed() -> void:
	pass # Replace with function body.

func _on_quit_button_pressed() -> void:
	get_tree().quit()
