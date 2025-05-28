extends Node

@export var scene_to_load : PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Dialogic.signal_event.connect(_on_Dialogic_finished)
	Dialogic.start("res://Timelines/Test.dtl")


func _on_Dialogic_finished(argument: String):
	if argument == "finished":
		print("Dialogic finished")
		_load_new_scene()

func _load_new_scene():
	get_tree().change_scene_to_packed(scene_to_load)
