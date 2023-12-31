extends Node
class_name BattleUIManager
var ragnahildaHeatlhbar : HealthBarController = null
var bossHealthBar : HealthBarController = null
var noteRails : NoteRails = null

func _ready():
	ragnahildaHeatlhbar = $RagnagildaHPBar
	bossHealthBar = $BossHPBar
	noteRails = $NoteRails

func on_character_health_changed(ragnahildaHealth , bossHealth):
	print(ragnahildaHealth,"---", bossHealth)
	ragnahildaHeatlhbar.SetLife(ragnahildaHealth)
	bossHealthBar.SetLife(bossHealth)



func _on_base_battle_attack_mode_changed(attacking):
	noteRails.on_attack_mode_changed(attacking)
