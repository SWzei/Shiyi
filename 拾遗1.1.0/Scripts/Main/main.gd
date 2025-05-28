extends Node2D

@onready var minimap = $MinimapUI
@onready var camera = $CanvasLayer/CameraButton
func _ready():
	minimap.visible = Global.minimap_on
	camera.visible = Global.camera_on
	
