extends Node

#var next_scene : String = "main"

@onready var tipScreen = $Tips
@onready var text = $Tips/text

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.stop_music()
	Dialogic.signal_event.connect(_on_Dialogic_signal)
	Dialogic.start("Library")


func _on_Dialogic_signal(argument: String):
	if argument == "Finished":
		print("Dialogic finished")
		_load_tips()
	elif argument == "Hint":
		print("Hint signal received")

func _load_tips():
	tipScreen.visible = true
	var tween = create_tween()
	tween.tween_property(text, "modulate:a", 1.0, 1.0)
	tween.finished.connect(_load_new_scene)

func _load_new_scene():
	Global.play_music("res://Autio/main.mp3")
	Global.switch_scene("main")
