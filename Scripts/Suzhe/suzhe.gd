extends Node2D

func _ready():
	Global.play_music("res://Autio/suzhe.mp3")
	self.modulate.a = 0
	_play_tween()

func _play_tween():
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 1.0, 1.0)
