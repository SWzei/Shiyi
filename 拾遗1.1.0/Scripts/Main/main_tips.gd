extends CanvasLayer

@onready var content_text : Label = $Content
@onready var middle_text : Label = $MiddleTips
var tips : Array[String] = ["请前往南京大学图书馆", "请前往南京大学北门", "前往北大楼", "前往校史馆", "前往大礼堂", "前往苏浙体育场", "前往教学楼", "全地图已解锁"]

@onready var minimap = $"../MinimapUI"
@onready var Layer = $"."
@onready var shot = $"../Papershot"

func _process(delta):
	for i in 7:
		if Global.structure[i] == false:
			content_text.text = tips[i]
			break
	if Global.structure[6] == true:
		content_text.text = tips[7]
		


func _on_camera_button_pressed() -> void:
	minimap.visible = false
	Layer.visible = false
	await get_tree().create_timer(0.1).timeout
	shot.take_screenshot()
	await get_tree().create_timer(0.1).timeout
	minimap.visible = true
	Layer.visible = true
	
	middle_text.visible = true
	middle_text.text = "照片已保存！"
	await get_tree().create_timer(1.0).timeout
	middle_text.visible = false
