extends Control

@export var scene_to_load : PackedScene
var answer: Array = ["金陵大学","顾毓琇","江谦","匡亚明","程开甲","仲盛"]
var current_hint_index: int = 0
var current_round_index: int = 0
var total_rounds: int = 6
var is_waiting_for_next_round: int = 0;
var typing_speed
var answer_container
var hint_label
var progress
var keyboard_lock = false
var cancel_typing = false
var jump_over_intro = false
var hints = [
	["它是南京大学的前身之一","汇文书院是它最早的源头","金陵中学是它的附属中学"],
	["学者、教授、诗人，清风、明月、劲松","他曾任国立中央大学时期校长","南大校史博物馆馆名正是由他题写"],
	["他的道号为阳复子","他筹办南京高等师范学校并出任校长","他是南京大学校歌词作者"],
	["他被称为\"孔学泰斗\"","他于1980年在全国首倡开设\"大学语文\"课","南京大学有一个学院以他的名字命名"],
	["他是著名理论物理学家","诺贝尔物理学奖获得者马克斯·玻恩指导过他四年","他是\"两弹一星功勋奖章\"获得者"],
	["他于2012年任南京大学计算机系教授","他自2022年所开设的离散数学课深受同学喜爱","他是现任软件学院院长"]
]
var introductions = [
	"金陵大学是由汇文书院和其它两个小书院基督书院、益智书院合并而成的，随后又吸纳了金陵女子文理学院，最后在1952年全国高校院系调整中，其文学院、理学院与原国立南京大学文、理学院合建为新的南京大学。金陵大学其余院系均分出，与相关大学院系组建众多新高校。如今南大鼓楼校区的北大楼、大礼堂、图书馆等均为金陵大学时期的建筑。\n",
	"顾毓琇（1902-2002），字一樵，中国近代史上的文理大师。他是中国现代电机工程先驱，也有深厚的文学造诣，创造诗歌、喜剧，弘扬传统文化。他于1944-1945担任国立中央大学校长，期间致力于稳定战时教育、推动学科发展。在2002年南大校史馆建成之时，百岁老人顾毓琇为其题写了馆名。\n",
	"江谦（1876-1942），字易园，道号阳复子。他是中国近代教育事业的先驱。1914年，他被任命为南京高等师范学校校长，在两江师范学堂原址办学。1915年，李叔同应江谦之聘，兼任高国师国画音乐教师。次年，由江谦作词，李叔同作曲的《南京高等师范学校校歌》就应运而生了。\n",
	"匡亚明（1906－1996），马克思主义思想理论家、教育家。他多年钻研孔子思想，被学术界誉为\"孔学泰斗\"。他于1963-1966，1978-1982年两度担任南京大学党委书记兼校长，在此期间，他大力倡导通识教育，并于1980年在全国率先开办\"大学语文\"通识课程。为纪念他，在他诞辰100周年之际，南京大学将基础学科教育书院命名为匡亚明学院。\n",
	"程开甲（1918-2018），中共党员，中国科学院院士，\"两弹一星功勋奖章\"获得者。在英国爱丁堡留学期间，他师从马克斯·玻恩，学习量子力学，并结识了国际许多顶尖物理学家。1950年，他拒绝了波恩的挽留，毅然回国建设祖国。两年后，他出任南大物理系副教授。1960年，他接命领导中国第一颗原子弹、氢弹研制工作，隐姓埋名工作二十余年。\n",
	"仲盛（1974-至今），电气电子工程师学会会士，中国计算机学会会士，南京大学软件学院院长。他在南大本科就读时期便以博识闻名，后赴美留学，在耶鲁拿到了博士学位。留学期间，他认识到美国大学教育模式的优势。回国后，他致力于推动课程改革，缓解学生对学分获取的压力，尝试唤醒最本真的思考的乐趣。\n"
]
var word_hint = [
	[1,0,3,2],
	[2,0,1],
	[1,0],
	[2,0,1],
	[0,2,1],
	[1,0]
]

func _ready():
	hint_label = $PanelContainer/MarginContainer/VBoxContainer/HintLabel
	progress = $Progress
	start_the_round()

func apply_font_to(node: Control, font_path: String, size: int):
	var font_file := load(font_path)
	var font := FontFile.new()
	font.font_data = font_file
	node.add_theme_font_override("font", font)
	node.add_theme_font_size_override("font_size", size)



func start_the_round():
	spawn_answer_boxes()
	$Timer.wait_time = 5
	$Timer.start()
	current_hint_index = 0
	hint_label.text = "提示："
	apply_font_to(hint_label, "res://Fonts/SourceHanSansCN-VF.otf", 48)
	hint_label.add_theme_color_override("font_color", Color(1, 1, 1))
	hint_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	hint_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	apply_font_to(progress, "res://Fonts/SourceHanSansCN-VF.otf", 36)
	progress.text = str(current_round_index + 1) + "/" + str(total_rounds)
	show_next_hint()
	set_process_input(true)

func spawn_answer_boxes():	
	# 清除 PanelContainer2 中旧的 AnswerContainer（如果有）
	var panel2 = $PanelContainer/MarginContainer/VBoxContainer/PanelContainer2
	for child in panel2.get_children():
		child.queue_free()

	# 创建一个新的 MarginContainer，用于包裹 AnswerContainer
	var margin_container = MarginContainer.new()
	
	# 动态设置边距（例如：根据格子数量调整左右 margin）
	var char_count = answer[current_round_index].length()
	var margin_value = (8 - char_count) * 50  # 举例：字少就宽一点，字多就窄一点    4:210 3:240 2:270
	if char_count == 2:
		margin_value = 290
	elif char_count == 3:
		margin_value = 180
	elif char_count == 4:
		margin_value = 60
	else:
		print("Invalid char_count: %d" % char_count)
	margin_value = clamp(margin_value, 10, 400)
	margin_container.add_theme_constant_override("margin_left", margin_value)
	margin_container.add_theme_constant_override("margin_right", margin_value)
	margin_container.add_theme_constant_override("margin_top", 30)
	margin_container.add_theme_constant_override("margin_bottom", 30)

	# 创建新的 AnswerContainer（HBoxContainer）并加入到 MarginContainer
	var new_answer_container = HBoxContainer.new()
	new_answer_container.name = "AnswerContainer"  # 为了后续查找
	new_answer_container.alignment = BoxContainer.ALIGNMENT_CENTER
	new_answer_container.add_theme_constant_override("separation", 5 * (8 - char_count))
	margin_container.add_child(new_answer_container)
	answer_container = new_answer_container  # 更新全局变量

	# 添加到 UI 层级中
	panel2.add_child(margin_container)

	# 添加输入格子到 AnswerContainer
	for i in char_count:
		var box = LineEdit.new()
		box.max_length = 1
		box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		box.alignment = HORIZONTAL_ALIGNMENT_CENTER
		box.name = "Box_%d" % i
		apply_font_to(box, "res://Fonts/SourceHanSansCN-VF.otf", 56)
		new_answer_container.add_child(box)


func typewriter_show(text: String, introsign: bool) -> void:
	var tempwordcnt := 0
	if introsign:
		hint_label.text = text
		typing_speed = 15
		hint_label.visible_characters = 5
	else:
		tempwordcnt = hint_label.get_total_character_count()
		hint_label.text += text
		typing_speed = 10
		hint_label.visible_characters = 0

	var typing_time := 0.0
	while hint_label.visible_characters < hint_label.get_total_character_count():
		if cancel_typing:
			hint_label.visible_characters = hint_label.get_total_character_count()
			cancel_typing = false
			break
		typing_time += get_process_delta_time()
		hint_label.visible_characters = tempwordcnt + int(typing_speed * typing_time)
		await get_tree().process_frame


func show_next_hint():
	if current_hint_index < hints[current_round_index].size():
		print("Showing hint: %s" % hints[current_round_index][current_hint_index])
#		hint_label.text += "\n" + str(current_hint_index+1) + ". " + hints[current_round_index][current_hint_index]
		var hint_text = "\n" + str(current_hint_index+1) + ". " + hints[current_round_index][current_hint_index]
		await typewriter_show(hint_text, 0)
		current_hint_index += 1
	else:
		$Timer.stop()
		$Timer.wait_time = 10
		$Timer.start()


func _on_Timer_timeout():
	if is_waiting_for_next_round == 0:
		if current_hint_index >= hints[current_round_index].size() + word_hint[current_round_index].size():
			$Timer.stop()
			return
		show_next_hint()
		if current_hint_index >= hints[current_round_index].size():
			var box_index = word_hint[current_round_index][current_hint_index - hints[current_round_index].size()]
			var hint_box = answer_container.get_child(box_index)
			hint_box.text = answer[current_round_index][word_hint[current_round_index][current_hint_index - hints[current_round_index].size()]]
#			hint_box.grab_focus()
			hint_box.add_theme_color_override("font_color", Color.YELLOW)
			tween_box(hint_box)
			current_hint_index += 1

	if is_waiting_for_next_round == 1:
		$Timer.stop()
		is_waiting_for_next_round = 0
		for child in answer_container.get_children():
			child.queue_free()
		start_the_round()
	if is_waiting_for_next_round == -1:
#		go_to_next_scene()
		_load_new_scene()

func _input(event):
	if keyboard_lock:
		if jump_over_intro:
			hint_label.visible_characters = hint_label.get_total_character_count()
			keyboard_lock = false
			jump_over_intro = false
		else:
			jump_over_intro = true
		return
	if event is InputEventKey and event.pressed and event.keycode == KEY_ENTER:
		if is_waiting_for_next_round == -1:
			print("222")
#			go_to_next_scene()
			_load_new_scene()
		elif is_waiting_for_next_round == 1:
			is_waiting_for_next_round = 0
			for child in answer_container.get_children():
				child.queue_free()
			start_the_round()
		else:
			var user_answer := ""
			for box in answer_container.get_children():
				user_answer += box.text.strip_edges()
			if user_answer == answer[current_round_index]:
				keyboard_lock = true
				cancel_typing = true
				apply_font_to(hint_label, "res://Fonts/SourceHanSansCN-VF.otf", 40)
				$Timer.stop()
				if current_round_index < total_rounds - 1:
					var intro_text = "回答正确!\n" + introductions[current_round_index]
					cancel_typing = false
					await typewriter_show(intro_text, 1)
					hint_label.text += "Enter 键进入下一题...\n"
					hint_label.visible_characters = hint_label.get_total_character_count()
					current_round_index += 1
					current_hint_index = 0
					is_waiting_for_next_round = 1
					$Timer.wait_time = 30
					$Timer.start()
				else:
					print("111")
					is_waiting_for_next_round = -1
					var intro_text = "回答正确!\n" + introductions[current_round_index]
					cancel_typing = false
					await typewriter_show(intro_text, 1)
					hint_label.text += "Enter 键以继续...\n"
					hint_label.visible_characters = hint_label.get_total_character_count()
					$Timer.wait_time = 30
					$Timer.start()
				keyboard_lock = false
			else:
				play_wrong_feedback()

func play_wrong_feedback():
	for box in answer_container.get_children():
		tween_box(box)
		"""
		var tween = get_tree().create_tween()
		tween.tween_property(box, "position:x", box.position.x + 5, 0.05).set_trans(Tween.TRANS_SINE)
		tween.tween_property(box, "position:x", box.position.x - 5, 0.05).set_trans(Tween.TRANS_SINE)
		tween.tween_property(box, "position:x", box.position.x, 0.05)
		"""

func tween_box(box: LineEdit):
	var tween = get_tree().create_tween()
	tween.tween_property(box, "position:x", box.position.x + 5, 0.05).set_trans(Tween.TRANS_SINE)
	tween.tween_property(box, "position:x", box.position.x - 5, 0.05).set_trans(Tween.TRANS_SINE)
	tween.tween_property(box, "position:x", box.position.x, 0.05)

"""
func go_to_next_scene():
	print("Going to next scene\n")
	get_tree().change_scene_to_file("res://Scenes/SchoolHistoryMuseum/SchoolHistoryMuseum2.tscn")
"""

func _load_new_scene():
	get_tree().change_scene_to_packed(scene_to_load)
