extends Node

var coin_count : int = 0

#skin
var player_skin : int = 1

#health
var max_health : int = 7

#current mode
var playscreen = false

#current level props
var total_levels : int = 5
var cur_level : int = 1
var cur_level_text : String

#level locked
var level_unlocked : Array[bool] = [1, 0, 0, 0, 0, 0]

#orienteering settings
var controller_unlockd : Array[bool] = [0, 0, 0, 0]
var controller_number : Array[int] = [21, 47, 19, 59]

func _ready():
	level_unlocked.resize(total_levels)
	level_unlocked.fill(false)
	level_unlocked[0] = 1
