extends Node

#Structure Unlock
var structure : Array[bool] = [0, 0, 0, 0, 0, 0, 0, 0, 0]
var book_choices : Array[int] = [0, 0, 0, 0, 0, 0, 0, 0, 0]

var cur_pos : Vector2 = Vector2(0, -450)
var cur_page : int

var camera_on = false
var minimap_on = false


func change_scenes(path : String):
	get_tree().change_scene_to_file(path)
