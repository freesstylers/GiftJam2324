extends Node2D
class_name Note 
#Note appearance related
@export var MissEffect : PackedScene = null
@export var OkEffect : PackedScene = null
@export var GreatEffect : PackedScene = null
@export var PerfectEffect : PackedScene = null
var noteSprite : Sprite2D = null
#Note hitting related
var myNoteType : GiftJamGlobals.NoteType = GiftJamGlobals.NoteType.UP 
var noteWasHit : bool = false
#Note fade out related
var myPathFollow2DContainer : PathFollow2D = null
var fadingStartPathPercentageStart : float = 0.5
var fadeDuration : float = 0.25
var fadeStarted : bool = false

func _ready():
	myPathFollow2DContainer = self.get_parent() as PathFollow2D
	
func _process(_delta):
	if not fadeStarted and myPathFollow2DContainer and myPathFollow2DContainer.progress_ratio >= fadingStartPathPercentageStart:
		FadeAway(fadeDuration)

func SetNoteType(type: GiftJamGlobals.NoteType, fadeOutStartPath: float, fadeOutDuration: float):
	myNoteType = type
	match type:
		GiftJamGlobals.NoteType.UP:
			noteSprite = $PlayerNotes/Up
		GiftJamGlobals.NoteType.DOWN:
			noteSprite = $PlayerNotes/Down
		GiftJamGlobals.NoteType.LEFT:
			noteSprite = $PlayerNotes/Left
		GiftJamGlobals.NoteType.RIGHT:
			noteSprite = $PlayerNotes/Right
	$PlayerNotes/Up.visible = myNoteType == GiftJamGlobals.NoteType.UP
	$PlayerNotes/Down.visible = myNoteType == GiftJamGlobals.NoteType.DOWN
	$PlayerNotes/Left.visible = myNoteType == GiftJamGlobals.NoteType.LEFT
	$PlayerNotes/Right.visible = myNoteType == GiftJamGlobals.NoteType.RIGHT
	
	fadingStartPathPercentageStart = fadeOutStartPath
	fadeDuration = fadeOutDuration

func GetNoteWasHit():
	return noteWasHit

func NoteHit(noteType : GiftJamGlobals.NoteType, noteHitStatus : GiftJamGlobals.NoteHitStatus ) -> GiftJamGlobals.NoteHitStatus :
	noteWasHit = true
	var hitResult : GiftJamGlobals.NoteHitStatus  = GiftJamGlobals.NoteHitStatus.MISS
	match noteHitStatus:
		GiftJamGlobals.NoteHitStatus.OK:
			if noteType == myNoteType:
				ShowFeedback(Color.ORANGE, OkEffect.instantiate())
				hitResult = GiftJamGlobals.NoteHitStatus.OK
		GiftJamGlobals.NoteHitStatus.GREAT:
			if noteType == myNoteType:
				ShowFeedback(Color.YELLOW, GreatEffect.instantiate())
				hitResult = GiftJamGlobals.NoteHitStatus.GREAT
		GiftJamGlobals.NoteHitStatus.PERFECT:
			if noteType == myNoteType:
				ShowFeedback(Color.GREEN, PerfectEffect.instantiate())
				hitResult = GiftJamGlobals.NoteHitStatus.PERFECT
	if hitResult == GiftJamGlobals.NoteHitStatus.MISS:
		ShowFeedback(Color.RED, MissEffect.instantiate())
	return hitResult

#Adjust the sprite and spawn some effect depending on how well the player hit the note
func ShowFeedback(NoteHitColor, EffectSpawned):
	#Sprite color is updated
	noteSprite.modulate = NoteHitColor
	#Spawned feedback's position is set to my position and added as a child of the globals
	EffectSpawned.global_position = global_position
	GiftJamGlobals.add_child(EffectSpawned)

#Fade out of the note whenever it surpasses the NoteHitter
func FadeAway(fDuration : float):	
	fadeStarted = true
	var myTween : Tween = null
	myTween = self.create_tween().set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN)
	myTween.set_parallel(true)
	myTween.tween_property(noteSprite, "modulate:a", 0, fDuration)
	myTween.tween_callback(self.queue_free).set_delay(fDuration) #Free this whole object after the fade out
