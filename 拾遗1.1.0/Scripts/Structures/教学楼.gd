extends StaticBody2D

@export var scene_to_load : PackedScene
@export var sequence : int = 0

@onready var player = $"../../../Player"

func _on_area_2d_body_entered(body: Node2D) -> void:
	if not body.is_in_group("Player"):
		return
	
	await get_tree().create_timer(0.5).timeout
	
	var judge = true
	for i in sequence:
		if Global.structure[i] == false:
			judge = false
	if Global.structure[sequence] == false and judge == true:
		call_deferred("_load_new_scene")
		Global.structure[sequence] = true

func _load_new_scene():
	Global.cur_pos = player.global_position
	get_tree().change_scene_to_packed(scene_to_load)
