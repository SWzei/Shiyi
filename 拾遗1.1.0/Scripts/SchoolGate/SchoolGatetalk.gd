extends Node

var next_scene : String = "res://Scenes/Main/main.tscn"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Dialogic.signal_event.connect(_on_Dialogic_signal)
	Dialogic.start("SchoolGate")


func _on_Dialogic_signal(argument: String):
	if argument == "Finished":
		print("Dialogic finished")
		$Hint.visible = false
		_load_new_scene()
	
	if argument == "Hint":
		print("Hint signal received")
		$Hint.visible = true

func _load_new_scene():
	get_tree().change_scene_to_file(next_scene)
