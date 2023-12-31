extends Node
class_name BattleManager

@export var SONG_BPM : int = 130
@export var PlayMetronome : bool = false
@export var NumAttacksPerAttack : int = 4
@export var Enemy : GiftJamGlobals.Battle
var UIManager : BattleUIManager = null

var numTimesToAttack : int = 1
var Attacking : bool = false

var playerHealth : float = 100
var enemyHealth : float = 100
var noteRail : NoteRails = null

var battleSong : AudioStreamPlayer = null
var metronomeSound : AudioStreamPlayer2D = null
var BPM_TIMER : Timer = null

var notesInRail : int = 0

signal attack_mode_changed(attacking : bool)

func _ready():
	battleSong = $BattleSong
	metronomeSound = $MetronomeSound
	BPM_TIMER = $BPM_TIMER
	
	UIManager = $UI/Container
	noteRail = $UI/Container/NoteRails
	
	var time_per_bpm = 60.0 / SONG_BPM
	BPM_TIMER.wait_time = time_per_bpm
	BPM_TIMER.start()
	
	GiftJamGlobals.connect("Fight_Start", Start_Battle)
	GiftJamGlobals.connect("Note_Hit_Result", note_hit_result)
	GiftJamGlobals.connect("LifeChanged", on_life_changed)
	Start_Battle()
	
func ChangeAttackMode(newMode : bool):
	Attacking = newMode
	attack_mode_changed.emit(Attacking)

func SendNotesToRail():
	notesInRail= NumAttacksPerAttack
	var newSet = []
	newSet.append(GiftJamGlobals.NoteType.NONE) #Start of the rail
	for i in range(NumAttacksPerAttack):
		newSet.append(1 + (randi()%4))
		#newSet.append(1 + 0)
	newSet.append(GiftJamGlobals.NoteType.NONE) #End of the rail
	noteRail.AddKeyNoteSet(newSet)
		
func note_hit_result(result : GiftJamGlobals.NoteHitStatus, noteType: GiftJamGlobals.NoteType):
	notesInRail = notesInRail -1
	if notesInRail <= 0:
		numTimesToAttack = numTimesToAttack -1
		if numTimesToAttack <= 0:
			numTimesToAttack = GetNumTimesToAttack()
			ChangeAttackMode(not Attacking)
		SendNotesToRail()

func GetNumTimesToAttack():
	#Guille has always only one turn
	if Enemy == GiftJamGlobals.Battle.G:
		return 1
	elif Enemy == GiftJamGlobals.Battle.P:
		#Finished attacking? now Cleon has 2 turns
		if Attacking:
			return 2
		#Players turn to attack? he has only 1 turn
		else:
			return 1
	else:
		#Finished attacking? now Pedro Pablo has 2 turns
		if Attacking:
			return 2
		#Players turn to attack? he has only 1 turn
		else:
			return 1

func BPM_Notification():
	if PlayMetronome:
		metronomeSound.play()
	GiftJamGlobals.BPM_Notification.emit()
	
func Start_Battle():
	ChangeAttackMode(true)
	noteRail.SetBPM(SONG_BPM)
	SendNotesToRail()

func on_life_changed(who : GiftJamGlobals.characterHit, quantity : int):
	if who == GiftJamGlobals.characterHit.Enemy:
		enemyHealth -= quantity
		print("EnemyHealth: %d" % enemyHealth)
		
		if enemyHealth <= 0:
			print ("VICTORY")
			get_tree().root.get_node("SceneManager").WinBattle()
			pass
		pass
	else:
		playerHealth -= quantity
		print("PlayerHealth: %d" % playerHealth)
			
		if playerHealth <= 0:
			print ("DEFEAT")
			get_tree().root.get_node("SceneManager").LoseBattle()
			pass
		pass
	UIManager.on_character_health_changed(playerHealth, enemyHealth)
	pass
