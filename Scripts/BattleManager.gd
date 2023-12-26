extends Node

@export var PlayMetronome : bool = false
@export var NumAttacksPerAttack : int = 3 

var Attacking : bool = false
var playerHealth : float = 100
var noteRail : NoteRails = null

var battleSong : AudioStreamPlayer2D = null
var metronomeSound : AudioStreamPlayer2D = null
var BPM_TIMER : Timer = null

var notesInRail : int = 0

signal attack_mode_changed(attacking : bool)

func _ready():
	noteRail = $NoteRails
	
	battleSong = $BattleSong
	
	metronomeSound = $MetronomeSound
	BPM_TIMER = $BPM_TIMER
	var time_per_bpm = 60.0 / GiftJamGlobals.GIFJAM_BPM
	BPM_TIMER.wait_time = time_per_bpm
	BPM_TIMER.start()
	
	GiftJamGlobals.connect("Fight_Start", Start_Battle)
	GiftJamGlobals.connect("Note_Hit_Result", note_hit_result)
	Start_Battle()
	
func ChangeAttackMode(newMode : bool):
	Attacking = newMode
	attack_mode_changed.emit(Attacking)

func SendNotesToRail():
	notesInRail= NumAttacksPerAttack
	for i in range(NumAttacksPerAttack):
		noteRail.AddKeyNote(2 + i, randi() % 4)
		
func note_hit_result(result : GiftJamGlobals.NoteHitStatus):
	notesInRail = notesInRail -1
	if notesInRail <= 0:
		ChangeAttackMode(not Attacking)
		SendNotesToRail()
		
func BPM_Notification():
	if PlayMetronome:
		metronomeSound.play()
	GiftJamGlobals.BPM_Notification.emit()
	
func Start_Battle():
	ChangeAttackMode(true)
	SendNotesToRail()
