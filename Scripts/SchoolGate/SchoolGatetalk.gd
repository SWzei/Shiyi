extends Node

var next_scene : String = "main"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.stop_music()
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
	Global.switch_scene("main")
