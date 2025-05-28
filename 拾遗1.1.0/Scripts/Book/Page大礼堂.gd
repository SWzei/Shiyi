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
	subtitle.text = "聚光灯下的璀璨舞台"
	para_1.text = "    大礼堂的幕布拉开时，仿佛打开了另一个世界。元旦晚会上，街舞社的同学踩着鼓点在追光灯下旋转，彩色光束扫过穹顶的彩绘，连斑驳的琉璃都跟着跃动。我坐在观众席倒数第三排，看着台上好友青涩又投入的表演，跟着全场节奏挥舞荧光棒，礼堂的回声将欢呼放大数倍，那热烈的氛围至今仍在记忆里发烫，每一场演出都像一颗流星，在大礼堂的夜空里留下耀眼的轨迹。"
	if Global.book_choices[sequence] == 0:
		Global.book_choices[sequence] = 1
		_manage_page()

func _on_button_2_pressed() -> void:
	subtitle.text = "思想碰撞的智慧殿堂"
	para_1.text = "    学术讲座的日子，大礼堂总是座无虚席。著名学者站在讲坛上，背后投影幕布闪烁着前沿理论，木质座椅被坐得吱呀作响，却安静得能听见手中的笔在笔记本上滑动的沙沙声。记得那场人工智能通识课，教授用生动的案例剖析算法奥秘，每一位同学都聚精会神地倾听。互动环节，此起彼伏的提问声从礼堂各个角落响起，思想的火花就在这方空间里不断迸发，大礼堂的每一处角落，都吸收着知识的养分。"
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
		transition_text.text = "    不远处，苏浙体育场传来了欢声笑语，“难道是‘百团大战’？”，你疑惑着，快步向苏浙体育场走去。"
		var tween = create_tween()
		tween.tween_property(transition_text, "modulate:a", 1.0, 3.0)
		tween.tween_interval(3.0)
		tween.finished.connect(_change_scene)

func _change_scene():
	get_tree().change_scene_to_file("res://Scenes/Main/main.tscn")
