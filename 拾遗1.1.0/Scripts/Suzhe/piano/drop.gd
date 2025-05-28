extends Sprite2D  # 或 TextureRect

var speed = 2500  # 像素/秒
var piano_loca
var size
var is_falling = false
var parent_button
var ini_pos

func start_falling():
	position.y = ini_pos
	is_falling = true
	visible = true

func _ready():
	ini_pos = position.y
	visible = false
	if texture:
		size = texture.get_size() * scale
	else:
		print("警告：Sprite2D 没有贴图，size 获取失败")
		size = Vector2.ZERO  # 防止后续出错
	#size = texture.get_size() * scale
	parent_button = get_parent()

func _process(delta):
	if is_falling:
		if parent_button.texture_normal:
			piano_loca = parent_button.global_position.y - size .y
		position.y += speed * delta
		if position.y > piano_loca:  # 超出屏幕底部就删除
			visible = false  # 隐藏
			is_falling = false
		
