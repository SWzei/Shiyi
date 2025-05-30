extends Area2D

signal enter(text : String)

func _on_body_entered(body: Node2D) -> void:
	if PlayerStats.controller_unlockd[3] == true:
		enter.emit("恭喜通关！")
	else:
		enter.emit("未按顺序完成打卡！")
