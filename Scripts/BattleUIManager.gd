extends Node
class_name BattleUIManager
var ragnahildaHeatlhbar : HealthBarController = null
var bossHealthBar : HealthBarController = null

func _ready():
	ragnahildaHeatlhbar = $RagnagildaHPBar
	bossHealthBar = $BossHPBar

func on_character_health_changed(ragnahildaHealth , bossHealth):
	print(ragnahildaHealth,"---", bossHealth)
	ragnahildaHeatlhbar.SetLife(ragnahildaHealth)
	bossHealthBar.SetLife(bossHealth)
