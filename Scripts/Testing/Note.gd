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
var fadedIn : bool = false
var attackNote : bool = true

func _ready():
	myPathFollow2DContainer = self.get_parent() as PathFollow2D

func GetNoteWasHit():
	return noteWasHit

func SetNoteType(type: GiftJamGlobals.NoteType, fadeOutStartPath: float, fadeOutDuration: float, attacking : bool):
	myNoteType = type
	attackNote = attacking
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
	#Sprite color is updated
	if attackNote: 
		noteSprite.modulate = Color.BLUE
	else:
		noteSprite.modulate = Color.RED
	noteSprite.scale = Vector2(0,0)

func NoteHit(noteType : GiftJamGlobals.NoteType, noteHitStatus : GiftJamGlobals.NoteHitStatus ) -> GiftJamGlobals.NoteHitStatus :
	noteWasHit = true
	var hitResult : GiftJamGlobals.NoteHitStatus  = GiftJamGlobals.NoteHitStatus.MISS
	match noteHitStatus:
		GiftJamGlobals.NoteHitStatus.OK:
			if noteType == GetMyCorrectInput():
				ShowFeedback(OkEffect.instantiate())
				hitResult = GiftJamGlobals.NoteHitStatus.OK
		GiftJamGlobals.NoteHitStatus.GREAT:
			if noteType == GetMyCorrectInput():
				ShowFeedback(GreatEffect.instantiate())
				hitResult = GiftJamGlobals.NoteHitStatus.GREAT
		GiftJamGlobals.NoteHitStatus.PERFECT:
			if noteType == GetMyCorrectInput():
				ShowFeedback(PerfectEffect.instantiate())
				hitResult = GiftJamGlobals.NoteHitStatus.PERFECT
	if hitResult == GiftJamGlobals.NoteHitStatus.MISS:
		ShowFeedback(MissEffect.instantiate())
	return hitResult

func GetMyCorrectInput() -> GiftJamGlobals.NoteType:
	if not attackNote:
		match myNoteType:
			GiftJamGlobals.NoteType.UP:
				return GiftJamGlobals.NoteType.DOWN
			GiftJamGlobals.NoteType.DOWN:
				return GiftJamGlobals.NoteType.UP
			GiftJamGlobals.NoteType.LEFT:
				return GiftJamGlobals.NoteType.RIGHT
			GiftJamGlobals.NoteType.RIGHT:
				return GiftJamGlobals.NoteType.LEFT
	return myNoteType

func ShowFeedback(EffectSpawned):
	#Spawned feedback's position is set to my position and added as a child of the globals
	EffectSpawned.global_position = global_position
	GiftJamGlobals.add_child(EffectSpawned)

func on_note_hitter_pass(other):
	if other.is_in_group("notespawntrigger"):
		if not fadedIn:
			FadeIn(fadeDuration)
			fadedIn = true
		else:
			FadeOut(fadeDuration)

func FadeIn(fDuration : float):
	var myTween : Tween = null
	myTween = self.create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	myTween.set_parallel(true)
	myTween.tween_property(noteSprite, "scale", Vector2(0.1,0.1), fDuration)

func FadeOut(fDuration: float):
	var myTween : Tween = null
	myTween = self.create_tween().set_trans(Tween.TRANS_LINEAR)
	myTween.set_parallel(true)
	myTween.tween_property(noteSprite, "modulate:a", 0, fDuration)
	myTween.tween_callback(self.queue_free).set_delay(fDuration) #Free this whole object after the fade out	
