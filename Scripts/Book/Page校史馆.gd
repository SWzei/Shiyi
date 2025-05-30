extends Node2D

@export var target_scene: PackedScene
@export var sequence : int = 0
var can_click: bool = false

@onready var subtitle = $Subtitle
@onready var tips = $Tips
@onready var button1 = $Button1
@onready var button2 = $Button2
#@onready var button3 = $Button3
@onready var para_1 = $Content1
@onready var para_2 = $Content2
@onready var para_3 = $Content3
@onready var texture_rect = $TextureRect

@onready var transition = $"../../Transition"
@onready var transition_text = $"../../Transition/text"

func _ready():
	if Global.book_choices[sequence] == 0:
		tips.visible = true
		button1.visible = true
		button2.visible = true
		#button3.visible = true
		subtitle.modulate.a = 0
		para_1.modulate.a = 0
		para_2.modulate.a = 0
		para_3.modulate.a = 0
		texture_rect.modulate.a = 0
	else:
		if Global.book_choices[sequence] == 1:
			_on_button_1_pressed()
		if Global.book_choices[sequence] == 2:
			_on_button_2_pressed()

func _on_button_1_pressed() -> void:
	subtitle.text = "序厅凝岁月"
	para_1.text = "    还记得初次站在序厅，抬头望见 “诚，朴，雄，伟，励，学，敦，行” 的校训时，只觉得字如其意，庄严肃穆。楼梯两侧的墙面上，鼓楼和浦口两校区的规划平面图在写真灯箱下泛着柔和的光，不同时期的校门、校景照片依次排开。我曾驻足在一张民国时期的毕业合影前许久，照片里身着学士服的学长学姐们，眼神坚定而明亮，仿佛在诉说着那个年代的热血与理想。那时的我不会想到，多年后自己也会身着同样庄重的学士服，在校园里留下属于自己的青春定格。"
	if Global.book_choices[sequence] == 0:
		Global.book_choices[sequence] = 1
		_manage_page()

func _on_button_2_pressed() -> void:
	subtitle.text = "照片藏春秋"
	para_1.text = "    走进展区，1600多幅照片像是一本立体的历史相册。泛黄的老照片中，三江师范学堂的青砖黛瓦下，长衫飘飘的学子们在廊下读书；到了国立中央大学时期，战火纷飞里，师生们背着行囊西迁的身影令人动容；再到现代影像里，崭新的教学楼前，朝气蓬勃的同学们拿着实验器材谈笑风生。每一张照片我都曾细细端详，想象着照片背后的故事，也在其中寻找着与自己大学生活重叠的影子。"
	if Global.book_choices[sequence] == 0:
		Global.book_choices[sequence] = 2
		_manage_page()

func _manage_page():
	
	tips.visible = false
	button1.visible = false
	button2.visible = false
	#button3.visible = false
	
	await get_tree().create_timer(0.5).timeout
	var tween = create_tween()
	tween.tween_property(subtitle, "modulate:a", 1.0, 1.0)
	tween.tween_property(para_1, "modulate:a", 1.0, 3.0)
	tween.tween_interval(2.0)
	tween.tween_property(para_2, "modulate:a", 1.0, 3.0)
	tween.tween_interval(2.0)
	tween.tween_property(para_3, "modulate:a", 1.0, 3.0)
	tween.tween_interval(2.0)
	tween.tween_property(texture_rect, "modulate:a", 1.0, 3.0)
	tween.finished.connect(_on_tween_finished)

func _on_tween_finished():
	can_click = true

func _input(event):
	if event is InputEventMouseButton and event.pressed and can_click:
		Global.stop_music()
		transition.visible = true
		transition_text.modulate.a = 0
		transition_text.text = "    忽的，你想起刚刚解说过程中提及的大礼堂，“去那里看看吧”，你心想"
		var tween = create_tween()
		tween.tween_property(transition_text, "modulate:a", 1.0, 3.0)
		tween.tween_interval(3.0)
		tween.finished.connect(_change_scene)

func _change_scene():
	Global.switch_scene("main")
