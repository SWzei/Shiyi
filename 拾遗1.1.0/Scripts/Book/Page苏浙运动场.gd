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
#@onready var para_2 = $Content2
#@onready var para_3 = $Content3
@onready var texture_rect1 = $TextureRect1
@onready var texture_rect2 = $TextureRect2
@onready var texture_rect3 = $TextureRect3


@onready var transition = $"../Transition"
@onready var transition_text = $"../Transition/text"

func _ready():
	if Global.book_choices[sequence] == 0:
		tips.visible = true
		button1.visible = true
		button2.visible = true
		button3.visible = true
		subtitle.modulate.a = 0
		para_1.modulate.a = 0
		#para_2.modulate.a = 0
		#para_3.modulate.a = 0
		texture_rect1.modulate.a = 0
		texture_rect2.modulate.a = 0
		texture_rect3.modulate.a = 0
	else:
		if Global.book_choices[sequence] == 1:
			_on_button_1_pressed()
		if Global.book_choices[sequence] == 2:
			_on_button_2_pressed()
		if Global.book_choices[sequence] == 3:
			_on_button_3_pressed()

func _on_button_1_pressed() -> void:
	subtitle.text = "热血沸腾的竞技战场"
	para_1.text = "    发令枪响撕裂空气的瞬间，苏浙体育场就化作了青春的竞技场。短跑赛道上，选手们如离弦之箭冲过起跑线，运动鞋与塑胶跑道摩擦出尖锐的声响；长跑队伍中，汗水浸透衣衫的身影仍在咬牙坚持，每一步喘息都带着对极限的挑战。最令人血脉偾张的当属接力赛，交接棒时队友间默契的眼神交汇，伴随着观众席震耳欲聋的 “加油” 声浪，仿佛能掀翻体育场的天空。终点线前的冲刺时刻，冲过红线的选手弯腰扶膝大口喘气，而全场的欢呼早已将胜利的喜悦推向顶峰。"
	if Global.book_choices[sequence] == 0:
		Global.book_choices[sequence] = 1
		_manage_page()

func _on_button_2_pressed() -> void:
	subtitle.text = "绿茵场上的激情角逐"
	para_1.text = "    阳光倾洒在绿茵茵的草坪上，苏浙体育场的足球赛事总能点燃所有人的热情。球员们在草坪上如猎豹般奔跑，争抢、铲球、过人，动作一气呵成。记得那场院系对决，双方僵持不下，直到比赛尾声，我方前锋在禁区外突然起脚抽射，足球划出完美弧线直挂死角。进球的瞬间，替补席球员一跃而起冲向场内，观众席的呐喊声与跺脚声交织成激昂的战歌，挥舞的院旗与跳动的身影，将胜利的狂欢定格成永恒的画面。"
	if Global.book_choices[sequence] == 0:
		Global.book_choices[sequence] = 2
		_manage_page()

func _on_button_3_pressed() -> void:
	subtitle.text = "“百团大战”"
	para_1.text = "    每当 “百团大战” 拉开帷幕，苏浙体育场便化身五光十色的创意海洋。沿操场铺开的社团摊位上，色彩鲜艳的海报随风轻摆，新奇有趣的展品让人挪不开眼。社的钢琴即兴弹唱吸引大批同学驻足，钢琴旋律混着清唱声在空气中流淌；汉服社的同袍们身着华服，举手投足间尽显古典韵味；滑板社在空地上炫技，板轮与地面摩擦出炫酷的火花。同学们抱着宣传单穿梭其中，时而停下与社团成员热切交谈，时而被有趣的互动环节逗得开怀大笑，整个体育场都洋溢着对大学生活的无限憧憬。"
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
	tween.tween_property(texture_rect1, "modulate:a", 1.0, 2.0)
	tween.tween_interval(1.0)
	tween.tween_property(texture_rect2, "modulate:a", 1.0, 2.0)
	tween.tween_interval(1.0)
	tween.tween_property(texture_rect3, "modulate:a", 1.0, 2.0)
	tween.finished.connect(_on_tween_finished)

func _on_tween_finished():
	can_click = true

func _input(event):
	if event is InputEventMouseButton and event.pressed and can_click:
		transition.visible = true
		transition_text.modulate.a = 0
		transition_text.text = "    “这段经历，快要结束了吧。”你喃喃道。
									但是，离开之前，你还想再一次地站在教学楼前，最后回望一次中大路。"
		var tween = create_tween()
		tween.tween_property(transition_text, "modulate:a", 1.0, 4.0)
		tween.tween_interval(3.0)
		tween.finished.connect(_change_scene)

func _change_scene():
	get_tree().change_scene_to_file("res://Scenes/Main/main.tscn")
