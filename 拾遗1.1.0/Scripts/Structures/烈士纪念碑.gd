extends StaticBody2D

func _on_area_2d_body_entered(body: Node2D) -> void:
	if not body.is_in_group("Player"):
		return
	
	await get_tree().create_timer(0.5).timeout
	
	if Global.structure[8] == false:
		Global.structure[8] = true
