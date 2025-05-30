extends Node2D

@onready var sco = $Sprite2D

func _ready():
	sco.modulate.a = 0.8    # 设置透明度为 70%
