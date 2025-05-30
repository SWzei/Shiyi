extends Area2D

#@export var scene_to_load : PackedScene
# 改为通过 ButtonNode 找到 Button
@onready var button = $ButtonNode/Button
@onready var player = get_parent().get_parent().get_node("NJUer")  # 请根据你的真实结构调整

const DIALOG_PATH = "res://dialog/photography/timeline.dtl"

func _ready():
	button.visible = false
	button.pressed.connect(_on_button_pressed)
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	if not Dialogic.signal_event.is_connected(_change_to_photography):
		Dialogic.signal_event.connect(_change_to_photography)


func _on_body_entered(body):
	if body.name == "NJUer":
		button.visible = true

func _on_body_exited(body):
	if body.name == "NJUer":
		button.visible = false

func _on_button_pressed():
	button.visible = false
	if is_instance_valid(player):
		player.set_physics_process(false)  # 暂停玩家操作

	Dialogic.timeline_ended.connect(_on_dialogue_end, CONNECT_ONE_SHOT)
	Dialogic.start(DIALOG_PATH)

func _on_dialogue_end():
	if is_instance_valid(player):
		player.set_physics_process(true)  # 恢复玩家操作

func _change_to_photography(event_name: String):
	if event_name == "_change_to_photography":
	#get_tree().change_scene_to_file("res://scene_to_load/orienteering_to_be_fixed.tscn")
		_load_new_scene()

func _load_new_scene():
	Global.sz_cur_pos = player.global_position
	get_tree().change_scene_to_file("res://Scenes/Suzhe_scenes/album_suzhe.tscn")
