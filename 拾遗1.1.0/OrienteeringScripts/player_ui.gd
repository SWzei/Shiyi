extends CanvasLayer

@onready var health_container = $HeartContainer
@onready var heart = $HeartContainer/Heart
var hearts : Array = []

@onready var coin_text : Label= $CoinText
@onready var control_text : Label = $ControlOrder

@onready var player = get_parent()

@onready var level : Label = $Level
@onready var hearts_num : Label = $HeartsNum

@onready var stop = $StopButton
@onready var start = $StartButton
@onready var haze = $Haze


func _ready () -> void:
	hearts_num.visible = false
	
	hearts = health_container.get_children()
	
	player.OnUpdateHealth.connect(_update_hearts)
	player.OnUpdateScore.connect(_update_score)
	player.OnHealHealth.connect(_update_hearts)
	
	_update_hearts(player.health)
	_update_score(PlayerStats.coin_count)
	
	#show level
	await get_tree().create_timer(0.01).timeout
	level.visible = true
	level.text = PlayerStats.cur_level_text
	await get_tree().create_timer(3).timeout
	level.visible = false

func _update_hearts (health : int):
	if health <= 0:
		hearts[0].visible = true
	else:
		for i in len(hearts):
			hearts[i].visible = i < health
		

func _update_score (score : int):
	coin_text.text = "Coins: " + str(score)

func _on_stop_button_pressed() -> void:
	get_tree().paused = true
	stop.visible = false
	start.visible = true
	haze.visible = true

func _on_start_button_pressed() -> void:
	get_tree().paused = false
	stop.visible = true
	start.visible = false
	haze.visible = false


func _on_quit_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Suzhe_scenes/suzhe.tscn")
