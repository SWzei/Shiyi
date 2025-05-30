extends Node2D

@onready var minimap = $MinimapUI
@onready var camera = $CanvasLayer/CameraButton
@onready var book = $CanvasLayer/BookButton

@onready var music_player = $AudioStreamPlayer

func _ready():
	if Global.main_music_on:
		Global.play_music("res://Autio/main.mp3")
	
	minimap.visible = Global.minimap_on
	camera.visible = Global.camera_on
	book.visible = Global.book_on
	
	modulate.a = 0
	_play_start_tween()

func _play_start_tween():
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 1.0, 2.0)
