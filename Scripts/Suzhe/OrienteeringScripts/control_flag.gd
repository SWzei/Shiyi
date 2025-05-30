extends Area2D

@export var sequence : int = 0

signal judge(sequence : int)

func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group("Player"):
		return
	
	judge.emit(sequence)
	
		
	#await get_tree().create_timer(1).timeout
	#PlayerStats.cur_level += 1
	#PlayerStats.level_unlocked[PlayerStats.cur_level - 1] = true
	#call_deferred("_load_new_scene")
