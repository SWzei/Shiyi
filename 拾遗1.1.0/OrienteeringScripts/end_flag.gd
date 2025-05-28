extends Area2D

@export var scene_to_load = "res://Scenes/Suzhe_scenes/suzhe.tscn"

func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group("Player"):
		return
	
	if PlayerStats.controller_unlockd[3] == false:
		return
	
	await get_tree().create_timer(1.0).timeout
	call_deferred("_load_new_scene")

func _load_new_scene():
	get_tree().change_scene_to_file(scene_to_load)
