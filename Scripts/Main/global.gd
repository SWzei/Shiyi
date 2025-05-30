extends Node

#Structure Unlock
var structure : Array[bool] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
var book_choices : Array[int] = [0, 0, 0, 0, 0, 0, 0, 0, 0]
var map_unlocked : bool = false


var cur_pos : Vector2 = Vector2(0, -450)
var cur_page : int = 2
var sz_cur_pos : Vector2 = Vector2(900, 520)

var camera_on = false
var minimap_on = false
var book_on = false

var book_viewer = false

var main_music_on = false

#相册信息保存
var pics : Array[bool] = [0, 0, 0, 0]
var pic_names : Array[String] = ["", "", "", ""]

# 场景预加载字典
var preloaded_scenes := {
	"main": preload("res://Scenes/Main/main.tscn"),
	"book": preload("res://Scenes/Book/book.tscn"),
	"end_screen": preload("res://Scenes/Main/end_screen.tscn"),
	"library": preload("res://Scenes/Library/Library.tscn"),
	"school_gate": preload("res://Scenes/SchoolGate/SchoolGate.tscn"),
	
	"north_building": preload("res://Scenes/NorthBuilding/NorthBuilding.tscn"),
	"north_building2": preload("res://Scenes/NorthBuilding/NorthBuilding2.tscn"),
	
	"school_museum": preload("res://Scenes/SchoolHistoryMuseum/SchoolHistoryMuseum.tscn"),
	"question_scene": preload("res://Scenes/SchoolHistoryMuseum/QuestionScene.tscn"),
	"school_museum2": preload("res://Scenes/SchoolHistoryMuseum/SchoolHistoryMuseum2.tscn"),
	
	"school_hall": preload("res://Scenes/SchoolHall/SchoolHall.tscn"),
	"school_hall2": preload("res://Scenes/SchoolHall/SchoolHall2.tscn"),
	
	"suzhe": preload("res://Scenes/Suzhe_scenes/suzhe.tscn"),
	"piano": preload("res://Scenes/Suzhe_scenes/piano.tscn"),
	"piano2": preload("res://Scenes/Suzhe_scenes/photo_show.tscn"),
	"album": preload("res://Scenes/Suzhe_scenes/album_suzhe.tscn"),
	"orienteering": preload("res://Scenes/Suzhe_scenes/OrienteeringScenes/Orienteering.tscn"),

	"main_road": preload("res://Scenes/MainRoad/MainRoad.tscn")
}

# 当前场景引用（用于内存管理）
var current_scene: Node

var music_player : AudioStreamPlayer
var music_tween: Tween
var current_music_path: String = ""
var target_volume: float = 0.0

func _ready():
	music_player = AudioStreamPlayer.new()
	add_child(music_player)
	
	music_player.volume_db = -80.0  # 完全静音

func play_music(path: String, fade_in_duration: float = 1.0, fade_out_duration: float = 1.0):
	# 如果已经在播放相同音乐，不做任何操作
	if current_music_path == path and music_player.playing:
		return
	
	# 停止现有的渐变效果
	_stop_music_tween()
	
	# 记录当前音乐路径
	current_music_path = path
	
	# 创建新的渐变效果
	music_tween = create_tween().set_parallel(false)
	
	# 如果有音乐正在播放，先淡出
	if music_player.playing:
		music_tween.tween_property(music_player, "volume_db", -80.0, fade_out_duration)
		music_tween.tween_callback(func(): 
			music_player.stop()
			_load_and_play_music(path, fade_in_duration)
		)
	else:
		# 没有音乐播放，直接加载并淡入
		_load_and_play_music(path, fade_in_duration)

func _load_and_play_music(path: String, fade_in_duration: float):
	# 加载新音乐
	var music = load(path)
	if music:
		music_player.stream = music
		music_player.play()

		# 创建淡入效果
		_stop_music_tween()
		music_tween = create_tween()
		music_tween.tween_property(music_player, "volume_db", 0.0, fade_in_duration)
	else:
		push_error("无法加载音乐文件: " + path)

# 降低音量
func lower_volume(target_db: float = -10.0, duration: float = 1.0):
	if music_player.playing:
		_stop_music_tween()
		music_tween = create_tween()
		music_tween.tween_property(music_player, "volume_db", target_db, duration)
		target_volume = target_db

# 提高音量
func raise_volume(target_db: float = 0.0, duration: float = 1.0):
	if music_player.playing:
		_stop_music_tween()
		music_tween = create_tween()
		music_tween.tween_property(music_player, "volume_db", target_db, duration)
		target_volume = target_db

func stop_music(fade_out_duration: float = 1.0):
	if music_player.playing:
		_stop_music_tween()
		music_tween = create_tween()
		music_tween.tween_property(music_player, "volume_db", -80.0, fade_out_duration)
		music_tween.tween_callback(music_player.stop)
		current_music_path = ""

func _stop_music_tween():
	if music_tween and music_tween.is_valid():
		music_tween.kill()
		music_tween = null

# 添加暂停/恢复功能
func pause_music(fade_out_duration: float = 0.5):
	if music_player.playing:
		_stop_music_tween()
		music_tween = create_tween()
		music_tween.tween_property(music_player, "volume_db", -30.0, fade_out_duration)
		music_tween.tween_callback(music_player.set_stream_paused.bind(true))

func resume_music(fade_in_duration: float = 0.5):
	if music_player.stream and music_player.stream_paused:
		music_player.stream_paused = false
		_stop_music_tween()
		music_tween = create_tween()
		music_tween.tween_property(music_player, "volume_db", 0.0, fade_in_duration)

func switch_scene(target: String) -> void:
	call_deferred("_deferred_switch", target)

func _deferred_switch(target: String):
	# 1. 卸载旧场景
	if current_scene:
		current_scene.queue_free()
		await current_scene.tree_exited

	# 2. 实例化新场景
	var new_scene = preloaded_scenes[target].instantiate()

	# 3. 添加到场景树
	get_tree().root.add_child(new_scene)
	get_tree().current_scene = new_scene
	current_scene = new_scene
