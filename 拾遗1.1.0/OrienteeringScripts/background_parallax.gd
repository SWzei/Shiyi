extends Node2D

var parallax : float = 0.7
@onready var player = $"../Player"

func _process(delta):
	global_position = player.global_position * parallax
