extends Panel

@onready var skin_shop = $SkinShopScreen
@onready var Achievements = $AchievementsScreen

@onready var skin1_button = $SkinShopScreen/Skin1
@onready var skin2_button = $SkinShopScreen/Skin2
@onready var skin1_cur = $SkinShopScreen/Skin1_cur
@onready var skin2_cur = $SkinShopScreen/Skin2_cur

#Skin Shop Screen
func _on_skin_shop_button_pressed() -> void:
	skin_shop.visible = true

func _on_back_from_skin_shop_button_pressed() -> void:
	skin_shop.visible = false

func _on_skin_1_pressed() -> void:
	skin1_button.visible = false
	skin1_cur.visible = true
	skin2_button.visible = true
	skin2_cur.visible = false
	PlayerStats.player_skin = 1

func _on_skin_2_pressed() -> void:
	skin1_button.visible = true
	skin1_cur.visible = false
	skin2_button.visible = false
	skin2_cur.visible = true
	PlayerStats.player_skin = 2

#Achievements Screen
func _on_achievements_button_pressed() -> void:
	Achievements.visible = true

func _on_back_from_achievements_button_pressed() -> void:
	Achievements.visible = false



#Back
func _on_back_from_feature_button_pressed() -> void:
	visible = false
