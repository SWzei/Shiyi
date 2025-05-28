extends Control

@export var scene_to_load = "res://Scenes/Suzhe_scenes/suzhe.tscn"

@export var page_data : Array[String] = [
	"北大楼。",
	"三花",
	"大礼堂",
	"图书馆"
]

var current_page := 0
var page_image_paths := []
var save_path := "user://page_images.json"
var inserting_left := true

# 节点引用
@onready var file_dialog = $FileDialog
@onready var photo_left = $PageContainer/PhotoArea_left
@onready var photo_right = $PageContainer/PhotoArea_right
@onready var text_left = $PageContainer/PageContent_left
@onready var text_right = $PageContainer/PageContent_right
@onready var exit_button = $ExitButton

@onready var load_button_left = $PageContainer/LoadImageButton_left
@onready var load_button_right = $PageContainer/LoadImageButton_right

# 🆕 新增：取消图片按钮
@onready var cancel_button_left = $PageContainer/CancButton_left
@onready var cancel_button_right = $PageContainer/CancButton_right

func _ready():
	page_image_paths.resize(page_data.size())
	for i in page_image_paths.size():
		page_image_paths[i] = ""

	_load_saved_image_paths()

	file_dialog.filters = ["*.png ; PNG 图片", "*.jpg ; JPG 图片"]
	file_dialog.file_mode = FileDialog.FILE_MODE_OPEN_FILE
	file_dialog.current_dir = "res://scene_photos/"

	file_dialog.connect("file_selected", Callable(self, "_on_file_selected"))
	load_button_left.pressed.connect(_on_load_image_button_left_pressed)
	load_button_right.pressed.connect(_on_load_image_button_right_pressed)
	exit_button.pressed.connect(_on_exit_button_pressed)

	# 🆕 信号连接：取消图片按钮
	cancel_button_left.pressed.connect(_on_cancel_button_left_pressed)
	cancel_button_right.pressed.connect(_on_cancel_button_right_pressed)

	$PageContainer.visible = false
	exit_button.visible = false

	update_page()

func _on_cover_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		await get_tree().create_timer(0.3).timeout
		$Cover.visible = false
		$PageContainer.visible = true
		update_page()

func update_page():
	var left_index = current_page * 2
	var right_index = left_index + 1

	text_left.text = page_data[left_index] if left_index < page_data.size() else ""
	text_right.text = page_data[right_index] if right_index < page_data.size() else ""

	photo_left.texture = _load_texture_from_path(
		page_image_paths[left_index] if left_index < page_image_paths.size() else ""
	)
	photo_right.texture = _load_texture_from_path(
		page_image_paths[right_index] if right_index < page_image_paths.size() else ""
	)

	$PageContainer/PrevButton.visible = current_page > 0
	$PageContainer/NextButton.visible = (current_page + 1) * 2 < page_data.size()
	exit_button.visible = not $PageContainer/NextButton.visible

	# 🆕 自动隐藏取消按钮（如无图片）
	cancel_button_left.visible = page_image_paths[left_index] != ""
	cancel_button_right.visible = page_image_paths[right_index] != ""

func _on_next_button_pressed() -> void:
	current_page += 1
	update_page()

func _on_prev_button_pressed() -> void:
	if current_page > 0:
		current_page -= 1
		update_page()

func _on_exit_button_pressed() -> void:
	_save_image_paths()
	_load_new_scene()

func _load_new_scene():
	get_tree().change_scene_to_file(scene_to_load)

func _on_load_image_button_left_pressed() -> void:
	inserting_left = true
	file_dialog.popup_centered()

func _on_load_image_button_right_pressed() -> void:
	inserting_left = false
	file_dialog.popup_centered()

func _on_file_selected(path: String) -> void:
	var page_index = current_page * 2 + (0 if inserting_left else 1)
	if page_index >= page_image_paths.size():
		page_image_paths.resize(page_index + 1)
		for i in page_image_paths.size():
			if typeof(page_image_paths[i]) != TYPE_STRING:
				page_image_paths[i] = ""

	page_image_paths[page_index] = path

	var tex = _load_texture_from_path(path)
	if tex:
		if inserting_left:
			photo_left.texture = tex
		else:
			photo_right.texture = tex

	# ✅ 加这一行，刷新取消按钮状态
	update_page()

# 🆕 取消左页图片
func _on_cancel_button_left_pressed() -> void:
	var index = current_page * 2
	if index < page_image_paths.size():
		page_image_paths[index] = ""
		photo_left.texture = null
		_save_image_paths()
		update_page()

# 🆕 取消右页图片
func _on_cancel_button_right_pressed() -> void:
	var index = current_page * 2 + 1
	if index < page_image_paths.size():
		page_image_paths[index] = ""
		photo_right.texture = null
		_save_image_paths()
		update_page()

func _load_texture_from_path(path) -> Texture2D:
	if typeof(path) != TYPE_STRING or path == "":
		return null
	var tex = load(path)
	if tex and tex is Texture2D:
		return tex
	return null

func _save_image_paths():
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(page_image_paths))
		file.close()

func _load_saved_image_paths():
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path, FileAccess.READ)
		if file:
			var text = file.get_as_text()
			var data = JSON.parse_string(text)
			if data is Array:
				page_image_paths = data
			file.close()
