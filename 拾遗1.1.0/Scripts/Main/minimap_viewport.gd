extends SubViewport

@onready var camera = $Camera2D
@onready var player = $"../../../Player"

func _ready():
	world_2d = get_tree().root.world_2d

func _process(delta):
	camera.position = player.position
