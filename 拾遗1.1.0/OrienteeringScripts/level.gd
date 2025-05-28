extends Node2D

@export var level_text : String

func _ready():
	PlayerStats.cur_level_text = level_text
