extends Control

@onready var place : Node2D = $"地点"
@onready var Library : Node2D = $"地点/图书馆"
@onready var TeachingBuilding : Node2D = $"地点/教学楼"
@onready var NorthBuilding : Node2D = $"地点/北大楼"
@onready var SchoolHistoryMuseum : Node2D = $"地点/校史馆"
@onready var GreatHall : Node2D = $"地点/大礼堂"
@onready var SZ : Node2D = $"地点/苏浙运动场"

@onready var pages : Array[Node2D] = [Library, TeachingBuilding, NorthBuilding, SchoolHistoryMuseum, GreatHall, SZ]

@onready var close_button = $CloseButton
@onready var pre_button = $PreButton
@onready var next_button = $NextButton

var cur_page : int = Global.cur_page

func _ready():
	
	_set_cur_page(cur_page)
	_play_start_tween()
	
	Global.play_music("res://Autio/book.mp3")
	
	if Global.book_viewer == true:
		close_button.visible = true
		pre_button.visible = _find_former_page() != -1
		next_button.visible = _find_next_page() != -1
	else:
		close_button.visible = false
		pre_button.visible = false
		next_button.visible = false

func _play_start_tween():
	modulate.a = 0.2
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 1.0, 2.0)

func _set_cur_page(cur_page : int):
	for i in len(pages):
		if i == cur_page:
			Global.structure[cur_page] = true
			pages[i].visible = true
		else:
			pages[i].visible = false

func _on_pre_button_pressed() -> void:
	var former : int = _find_former_page()
	if former != -1:
		cur_page = former
		_set_cur_page(cur_page)
		next_button.visible = true
	if _find_former_page() == -1:
		pre_button.visible = false
	_play_mini_tween()
		
func _find_former_page() -> int:
	var exist = false
	var former_page : int
	for i in cur_page:
		if Global.book_choices[cur_page - i - 1] != 0:
			exist = true
			former_page = cur_page - i - 1
			break
	if exist:
		return former_page
	else:
		return -1

func _on_next_button_pressed() -> void:
	var next : int = _find_next_page()
	if next != -1:
		cur_page = next
		_set_cur_page(cur_page)
		pre_button.visible = true
	if _find_next_page() == -1:
		next_button.visible = false
	_play_mini_tween()

func _find_next_page() -> int:
	var exist = false
	var next_page : int
	for i in 5 - cur_page:
		if Global.book_choices[cur_page + i + 1] != 0:
			exist = true
			next_page = cur_page + i + 1
			break
	if exist:
		return next_page
	else:
		return -1

func _play_mini_tween():
	place.modulate.a = 0.2
	var tween = create_tween()
	tween.tween_property(place, "modulate:a", 1.0, 1.0)

func _on_close_button_pressed() -> void:
	Global.cur_page = cur_page
	Global.book_viewer = false

	Global.play_music("res://Autio/main.mp3")
	Global.switch_scene("main")
