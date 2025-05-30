@tool
class_name Papershot
extends Node
## 独立截图工具，按快捷键保存截图到 exe 同级 Album 文件夹

signal screenshot_saved(image: Image, path: String)
signal io_error(error: Error, path: String)

enum FileFormat { JPG, PNG }
const JPG = FileFormat.JPG
const PNG = FileFormat.PNG

@export var shortcut: Shortcut ## 绑定截图快捷键（如 Ctrl+Shift+S）
@export var file_format: FileFormat = JPG ## 选择保存格式
@export_range(0, 1, 0.01) var jpg_quality: float = 0.9 ## JPG 压缩质量（0-1）

func _input(event: InputEvent) -> void:
	if shortcut == null:
		return
	
	# 检测快捷键按下
	for shortcut_event in shortcut.events:
		if event.is_action_pressed(shortcut_event.as_text()):
			get_viewport().set_input_as_handled()
			take_screenshot()

func take_screenshot() -> Error:
	var path: String = _get_save_path()
	if path.is_empty():
		return ERR_FILE_CANT_OPEN
	
	var image: Image = get_viewport().get_texture().get_image()
	var err: Error
	
	match file_format:
		JPG: err = image.save_jpg(path, jpg_quality)
		PNG: err = image.save_png(path)
	
	if err == OK:
		screenshot_saved.emit(image, path)
	else:
		io_error.emit(err, path)
	return err

func _get_save_path() -> String:
	# 动态获取目标路径
	var target_dir: String
	if OS.has_feature("editor"):
		target_dir = "res://assets/screenshots/"  # 编辑器测试目录
	else:
		var exe_dir = OS.get_executable_path().get_base_dir()
		target_dir = exe_dir.path_join("Album")
	
	# 自动创建目录
	var dir = DirAccess.open(target_dir.get_base_dir())
	if dir:
		dir.make_dir_absolute(target_dir)
	else:
		push_error("Failed to create directory: ", target_dir)
		return ""
	
	# 生成唯一文件名
	var datetime = Time.get_datetime_string_from_system(false, true).replace(":", "-")
	var millis = "%03d" % (Time.get_ticks_msec() % 1000)  # 更精确的毫秒
	var extension = ".jpg" if file_format == JPG else ".png"
	
	return target_dir.path_join("Screenshot_%s-%s%s" % [datetime, millis, extension])
