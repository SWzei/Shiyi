extends Control

@onready var Library : Node2D = $"图书馆"
@onready var TeachingBuilding : Node2D = $"教学楼"
@onready var NorthBuilding : Node2D = $"北大楼"
@onready var SchoolHistoryMuseum : Node2D = $"校史馆"
@onready var GreatHall : Node2D = $"大礼堂"
@onready var SZ : Node2D = $"苏浙运动场"

@onready var pages : Array[Node2D] = [Library, TeachingBuilding, NorthBuilding, SchoolHistoryMuseum, GreatHall, SZ]

func _ready():
	var cur_page : int = Global.cur_page
	_set_cur_page(cur_page)
	modulate.a = 0
	_play_tween()

func _play_tween():
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 1.0, 2.0)

func _set_cur_page(cur_page : int):
	for i in len(pages):
		if i == cur_page:
			Global.structure[cur_page] = true
			pages[i].visible = true
		else:
			pages[i].visible = false
		

func _on_close_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main.tscn")
