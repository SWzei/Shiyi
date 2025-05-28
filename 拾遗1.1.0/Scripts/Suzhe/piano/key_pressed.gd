extends TextureButton

@onready var audio_player = $AudioStreamPlayer2D
#
#@export var key_code: Key = KEY_C
#@export var note_sound: AudioStream
#@onready var anim = $AnimationPlayer
#@onready var sound = $AudioStreamPlayer
#@onready var marker = $Marker2D
#
#func _ready():
	#sound.stream = note_sound
#
#func _process(delta):
	#if Input.is_key_pressed(key_code):
		#if not anim.is_playing():
			##anim.play("press")
			#sound.play()
			##spawn_effect()
#
##func spawn_effect():
	##var block = preload("res://FallingBlock.tscn").instantiate()
	##block.global_position = marker.global_position
	##get_tree().current_scene.add_child(block)
#
#func _process(delta):
	#if Input.is_action_just_pressed("play_note_c"):
		#key_pressed()
	#elif Input.is_action_just_released("play_note_c"):
		#key_released()

func key_pressed() -> void:
	self.button_pressed = true
	_on_pressed()
	
func key_released() ->void:
	self.button_pressed = false
func _on_pressed() -> void:
	var drop_sprite = $Drop_sprite  # 或者 get_node("DropSprite")
	drop_sprite.start_falling()
	if audio_player.playing:
		audio_player.stop()
	audio_player.play()
