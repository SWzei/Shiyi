extends Area2D

signal enter(text : String)

@export var text : String

func _on_body_entered(body: Node2D) -> void:
	enter.emit(text)
