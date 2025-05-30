extends Node2D

@export var target_scene: PackedScene
@export var sequence : int = 0
var can_click: bool = false

@onready var subtitle = $Subtitle
@onready var tips = $Tips
@onready var button1 = $Button1
@onready var button2 = $Button2
@onready var button3 = $Button3
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
		button3.visible = true
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
		if Global.book_choices[sequence] == 3:
			_on_button_3_pressed()

func _on_button_1_pressed() -> void:
	subtitle.text = "光影下的青春打卡地"
	para_1.text = "    每次路过北大楼，都能看到三三两两的同学举着手机、自拍杆，在爬满爬山虎的墙前凹造型。春日嫩绿的新叶、盛夏葱郁的绿意、深秋火红的斑斓，还有冬日褪去叶片后古朴的砖墙，四季变换的北大楼永远是朋友圈的 “顶流”。"
	if Global.book_choices[sequence] == 0:
		Global.book_choices[sequence] = 1
		_manage_page()

func _on_button_2_pressed() -> void:
	subtitle.text = "心灵栖息的静谧港湾"
	para_1.text = "    当学业压力让人喘不过气，我就会跑到北大楼旁的长椅上发呆。看着墙面上随风摇曳的爬山虎影子，听着偶尔传来的铜铃轻响，内心的烦躁渐渐平复。有时候，还会碰到流浪猫蜷在台阶角落晒太阳，这种与北大楼相伴的静谧时光，是大学生活里独有的治愈良药，让我在忙碌中寻得一方心灵的安宁。"
	if Global.book_choices[sequence] == 0:
		Global.book_choices[sequence] = 2
		_manage_page()

func _on_button_3_pressed() -> void:
	subtitle.text = "砖石铭刻的岁月丰碑"
	para_1.text = "    塔楼顶端的十字架与中式飞檐奇妙融合，恰似近代中国文化碰撞的缩影。作为国立中央大学时期的标志性建筑，北大楼的设计融合了西方古典建筑的对称美学与中国传统建筑的神韵，这种中西合璧的风格，暗合着那个年代知识分子 “汇通中西” 的理想。站在拱门前仰望，雕花窗棂的光影在青砖上交织，仿佛看见闻一多、宗白华等学者在此踱步沉思，他们既传承着千年文脉，又吸纳着世界新知，而北大楼正是这种文化精神的具象化身。"
	if Global.book_choices[sequence] == 0:
		Global.book_choices[sequence] = 3
		_manage_page()

func _manage_page():
	
	tips.visible = false
	button1.visible = false
	button2.visible = false
	button3.visible = false
	
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
		transition_text.text = "    此时，你突然产生了进一步了解南大校史的冲动，忽然记起南大的校史博物馆，决定前去参观。"
		var tween = create_tween()
		tween.tween_property(transition_text, "modulate:a", 1.0, 3.0)
		tween.tween_interval(3.0)
		tween.finished.connect(_change_scene)

func _change_scene():
	Global.switch_scene("main")
