extends Node2D

@export var level_text : String

func _ready():
	Global.play_music("res://Autio/Orienteering.mp3")
	
	PlayerStats.cur_level_text = level_text
	PlayerStats.controller_unlockd = [0, 0, 0, 0]
