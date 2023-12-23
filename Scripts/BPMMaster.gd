extends Node

@export var PlayMetronome : bool = false

var BPM_TIMER : Timer = null
var background_song = null
var backgroundSong : AudioStreamPlayer2D = null
var metronomeSound : AudioStreamPlayer2D = null

func _ready():
	backgroundSong = $SampleSong
	metronomeSound = $MetronomeSound
	BPM_TIMER = $BPM_Notifier
	
	var time_per_bpm = 60.0 / GiftJamGlobals.GIFJAM_BPM
	BPM_TIMER.wait_time = time_per_bpm
	BPM_TIMER.start()
	#var callable = func():GiftJamGlobals.BPM_Notification.emit()
	#call_deferred(callable)
	
func BPM_Notification():
	if PlayMetronome:
		metronomeSound.play()
	GiftJamGlobals.BPM_Notification.emit()
