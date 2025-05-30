extends CanvasLayer

@onready var content_text : Label = $Content
@onready var middle_text : Label = $MiddleTips
var tips : Array[String] = ["请前往图书馆(右侧)", "请前往北园南门(地图中下方)", "寻找北大楼(地图右上方)", "寻找校史馆(地图右下方)", "寻找大礼堂(地图中间部分)", "寻找苏浙运动场(地图左上方)", "前往教学楼(地图中央)", "全地图已解锁"]

@onready var minimap = $"../MinimapUI"
@onready var Layer = $"."
@onready var shot = $"../Papershot"

@onready var player = $"../Player"

func _ready():
	if Global.structure[0] == false:
		_present_move_tips()

func _process(delta):
	for i in 7:
		if Global.structure[i] == false:
			content_text.text = tips[i]
			break
	if Global.structure[6] == true:
		content_text.text = tips[7]
		

func _present_move_tips():
	middle_text.visible = true
	middle_text.text = "请按WASD移动"
	await get_tree().create_timer(5.0).timeout
	middle_text.visible = false

func _on_camera_button_pressed() -> void:
	minimap.visible = false
	Layer.visible = false
	await get_tree().create_timer(0.1).timeout
	shot.take_screenshot()
	await get_tree().create_timer(0.1).timeout
	minimap.visible = true
	Layer.visible = true
	
	middle_text.visible = true
	middle_text.text = "照片已保存至Album文件夹！"
	await get_tree().create_timer(1.0).timeout
	middle_text.visible = false


func _on_book_button_pressed() -> void:
	Global.cur_pos = player.global_position
	Global.book_viewer = true
	Global.switch_scene("book")
