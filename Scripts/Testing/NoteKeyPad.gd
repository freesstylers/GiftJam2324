extends Node2D

class_name NoteKeyPad

@export var KeypadSprite : Sprite2D = null
@export var TickScale : float = 0.75
var myTween:Tween = null

func _ready():
	GiftJamGlobals.connect("BPM_Notification", BPM_Received)
	myTween = self.create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT);
	BPM_Received()
	
func BPM_Received():
	if myTween.is_running():
		myTween.kill()
		
	KeypadSprite.scale = Vector2(1,1)
	myTween = self.create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT);
	myTween.tween_property(KeypadSprite, "scale", Vector2(TickScale,TickScale), 0.01)
	myTween.tween_property(KeypadSprite, "scale", Vector2(1,1), 0.12)
