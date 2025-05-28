extends Node

@onready var file_dialog = $FileDialog
@onready var sprite = $photo              # TextureRect
@onready var exit_button = $Button_exit  # Exit Button
@onready var open_button = $Button_open  # Open Button

func _ready():
	exit_button.visible = false
	
	# 设置文件对话框路径：编辑器模式下用 res://，导出后用 exe 同级目录
	if OS.has_feature("editor"):
		file_dialog.current_dir = "res://album"  # 编辑器测试目录
	else:
		var exe_dir = OS.get_executable_path().get_base_dir()
		file_dialog.current_dir = exe_dir.path_join("Album")
	
	file_dialog.filters = ["*.png ; PNG 图片", "*.jpg ; JPG 图片"]
	file_dialog.file_mode = FileDialog.FILE_MODE_OPEN_FILE

	# 连接信号
	file_dialog.file_selected.connect(_on_file_selected)
	open_button.pressed.connect(_on_button_open_pressed)
	exit_button.pressed.connect(_on_button_exit_pressed)

func _on_button_open_pressed() -> void:
	file_dialog.popup_centered()

func _on_file_selected(path: String):
	exit_button.visible = true
	print("Selected file:", path)
	var image = Image.new()
	var err = image.load(path)
	if err == OK:
		var texture = ImageTexture.create_from_image(image)
		sprite.texture = texture
	else:
		push_error("Failed to load image: " + path)

func _on_button_exit_pressed() -> void:
	get_tree().change_scene_to_file("res://album.tscn")
