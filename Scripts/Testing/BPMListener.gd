extends Node

class_name BPMListener

func _ready():
	GiftJamGlobals.BPM_Notification.connect(BPM_Received)

func BPM_Received():
	pass
