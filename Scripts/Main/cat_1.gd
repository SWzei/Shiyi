extends CharacterBody2D

@onready var middle_tips = $"../../../CanvasLayer/MiddleTips"

var current_tween: Tween 
var is_animating: bool = false 

func _on_area_2d_body_entered(body: Node2D) -> void:
	if not body.is_in_group("Player"):
		return
	
	if is_animating:
		return
	
	is_animating = true
	
	_play_tween()
	
	await get_tree().create_timer(2.0).timeout
	
	is_animating = false

func _play_tween():
	middle_tips.visible = true
	middle_tips.text = "教学楼的常客"
	middle_tips.modulate.a = 0.2
	
	current_tween = create_tween()
	
	current_tween.tween_property(middle_tips, "modulate:a", 1.0, 0.5)
	current_tween.tween_interval(1.0)
	current_tween.tween_property(middle_tips, "modulate:a", 0.0, 0.5)
	current_tween.tween_callback(func(): 
		middle_tips.visible = false
		middle_tips.modulate.a = 1.0
	)
