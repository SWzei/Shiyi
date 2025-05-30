extends Panel

@onready var text = $text


func _ready():
	visible = false
	text.modulate.a = 0
	
