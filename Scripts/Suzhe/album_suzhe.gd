extends Control

@onready var cover = $Cover
@onready var page_container = $PageContainer

@onready var pages = [
	{
		"node": $PageContainer/Page1,
		"textures": [$PageContainer/Page1/TextureRect1, $PageContainer/Page1/TextureRect2],
		"buttons": [$PageContainer/Page1/Button1, $PageContainer/Page1/Button2],
		"close_buttons": [$PageContainer/Page1/CloseButton1, $PageContainer/Page1/CloseButton2]
	},
	{
		"node": $PageContainer/Page2,
		"textures": [$PageContainer/Page2/TextureRect3, $PageContainer/Page2/TextureRect4],
		"buttons": [$PageContainer/Page2/Button3, $PageContainer/Page2/Button4],
		"close_buttons": [$PageContainer/Page2/CloseButton3, $PageContainer/Page2/CloseButton4]
	}
]

@onready var line_edits = [
	$PageContainer/Page1/LineEdit1,
	$PageContainer/Page1/LineEdit2,
	$PageContainer/Page2/LineEdit3,
	$PageContainer/Page2/LineEdit4
]

@onready var pre_button = $PageContainer/PreButton
@onready var next_button = $PageContainer/NextButton
@onready var exit_button = $ExitButton

var cur_page: int = 0
var current_tween: Tween

func _ready():
	Global.stop_music()
	cover.visible = true
	page_container.visible = false
	for i in 4:
		line_edits[i].text = Global.pic_names[i]
	
	_update_page_visibility()

func _on_cover_gui_input(event: InputEvent):
	if event is InputEventMouseButton and event.pressed:
		cover.hide()
		page_container.show()
		exit_button.visible = true
		_play_start_animation()

func _play_start_animation():
	if current_tween:
		current_tween.kill()
	
	page_container.modulate.a = 0.4
	current_tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	current_tween.tween_property(page_container, "modulate:a", 1.0, 0.6)

func _update_page_visibility():
	for i in pages.size():
		pages[i]["node"].visible = (i == cur_page)
	
	var current_page = pages[cur_page]
	for i in 2:
		var data_index = cur_page * 2 + i
		current_page["buttons"][i].visible = !Global.pics[data_index]
		current_page["close_buttons"][i].visible = Global.pics[data_index]
		current_page["textures"][i].visible = Global.pics[data_index]
	
	pre_button.disabled = (cur_page == 0)
	next_button.disabled = (cur_page == pages.size() - 1)
	
	for i in 4:
		Global.pic_names[i] = line_edits[i].text

func _on_pre_button_pressed():
	cur_page = max(cur_page - 1, 0)
	_update_page_visibility()

func _on_next_button_pressed():
	cur_page = min(cur_page + 1, pages.size() - 1)
	_update_page_visibility()

func _on_button_1_pressed() -> void:
	Global.pics[0] = true
	_update_page_visibility()

func _on_button_2_pressed() -> void:
	Global.pics[1] = true
	_update_page_visibility()

func _on_button_3_pressed() -> void:
	Global.pics[2] = true
	_update_page_visibility()

func _on_button_4_pressed() -> void:
	Global.pics[3] = true
	_update_page_visibility()

func _on_close_button_1_pressed() -> void:
	Global.pics[0] = false
	_update_page_visibility()

func _on_close_button_2_pressed() -> void:
	Global.pics[1] = false
	_update_page_visibility()

func _on_close_button_3_pressed() -> void:
	Global.pics[2] = false
	_update_page_visibility()

func _on_close_button_4_pressed() -> void:
	Global.pics[3] = false
	_update_page_visibility()

func _on_line_edit_1_text_submitted(new_text: String) -> void:
	_update_page_visibility()

func _on_line_edit_2_text_submitted(new_text: String) -> void:
	_update_page_visibility()

func _on_line_edit_3_text_submitted(new_text: String) -> void:
	_update_page_visibility()

func _on_line_edit_4_text_submitted(new_text: String) -> void:
	_update_page_visibility()
	
func _on_exit_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Suzhe_scenes/suzhe.tscn")
