extends Node

#var next_scene : String = "res://Scenes/Main.tscn"


func _ready() -> void:
	Global.stop_music()
	Dialogic.signal_event.connect(_on_Dialogic_signal)
	Dialogic.start("SchoolHall")


func _on_Dialogic_signal(argument: String):
	if argument == "Finished":
		print("Dialogic finished")
		_load_new_scene()

func _load_new_scene():
	Global.switch_scene("school_hall2")
