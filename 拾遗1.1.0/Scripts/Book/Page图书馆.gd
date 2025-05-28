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

@onready var transition = $"../Transition"
@onready var transition_text = $"../Transition/text"

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
	subtitle.text = "自习区的无声共鸣"
	para_1.text = "    图书馆的自习区永远弥漫着咖啡与纸张混合的气息。木质长桌上，有人对着电脑屏幕眉头紧锁敲代码，有人用荧光笔在专业书上圈圈画画，偶尔笔尖划过纸面的沙沙声，像极了春雨落在屋檐的节奏。靠窗的位置最抢手，冬日阳光斜斜铺在桌上，书页被风掀起一角，又轻轻落下，与翻书的动作形成无声的共鸣。"
	if Global.book_choices[sequence] == 0:
		Global.book_choices[sequence] = 1
		_manage_page()

func _on_button_2_pressed() -> void:
	subtitle.text = "书架迷宫里的寻宝之旅"
	para_1.text = "    穿梭在书架间，就像走进一座巨大的迷宫。社科类书架前，总有人踮着脚够顶层的典籍，梯子移动时与地面摩擦出细微声响；文学区的角落，偶尔能撞见低声朗诵诗歌的身影，声音混在书脊之间，仿佛文字有了生命。记得有次为写论文寻找冷门资料，在角落书架翻出一本布满灰尘的旧书，扉页上往届学长的读书笔记密密麻麻，那些跨越时空的思想痕迹，成了意外收获的宝藏。"
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
		transition.visible = true
		transition_text.modulate.a = 0
		transition_text.text = "    请努力完成任务，点亮所有的建筑，找回遗失的记忆吧！"
		var tween = create_tween()
		tween.tween_property(transition_text, "modulate:a", 1.0, 3.0)
		tween.tween_interval(3.0)
		tween.finished.connect(_change_scene)

func _change_scene():
	get_tree().change_scene_to_file("res://Scenes/Main/main.tscn")
