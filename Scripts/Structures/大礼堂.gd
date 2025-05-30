extends StaticBody2D

#@export var scene_to_load : PackedScene
@export var sequence : int = 0

@onready var player = $"../../../Player"

@onready var middle_tips = $"../../../CanvasLayer/MiddleTips"

var current_tween: Tween 
var is_animating: bool = false 

func _on_area_2d_body_entered(body: Node2D) -> void:
	if not body.is_in_group("Player"):
		return
	
	await get_tree().create_timer(0.5).timeout
	
	if Global.structure[sequence] == true:
		if is_animating:
			return
		is_animating = true
		_play_tween()
		await get_tree().create_timer(3.5).timeout
		is_animating = false
	
	var judge = true
	for i in sequence:
		if Global.structure[i] == false:
			judge = false
	if Global.structure[sequence] == false and judge == true:
		_load_new_scene()
		Global.cur_page = sequence

func _play_tween():
	middle_tips.visible = true
	middle_tips.text = "大礼堂"
	middle_tips.modulate.a = 0.2
	
	current_tween = create_tween()
	
	current_tween.tween_property(middle_tips, "modulate:a", 1.0, 0.5)
	current_tween.tween_interval(2.0)
	current_tween.tween_property(middle_tips, "modulate:a", 0.0, 1.0)
	current_tween.tween_callback(func(): 
		middle_tips.visible = false
		middle_tips.modulate.a = 1.0
	)

func _load_new_scene():
	Global.cur_pos = player.global_position
	Global.switch_scene("school_hall")
