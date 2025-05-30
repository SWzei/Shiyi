extends Node

@onready var texture_rect = $TextureRect
@onready var color_rect = $CanvasLayer/ColorRect

#var next_scene : String = "res://Scenes/NorthBuilding2.tscn"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.stop_music()
	color_rect.visible = false
	color_rect.modulate.a = 0
	Dialogic.signal_event.connect(_on_Dialogic_signal)
	Dialogic.start("NorthBuilding")


func _on_Dialogic_signal(argument: String):
	if argument == "Finished":
		print("Dialogic finished")
		_load_new_scene()
	
	if argument == "Shooting":
		print("Shooting signal received")
		color_rect.visible = true
		var tween = create_tween()
		tween.tween_property(color_rect, "modulate:a", 1, 0.1)
		tween.tween_property(color_rect, "modulate:a", 0, 0.2)
		tween.finished.connect(func(): color_rect.visible = false)

func _load_new_scene():
	Global.switch_scene("north_building2")
