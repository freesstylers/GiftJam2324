extends PathFollow2D
class_name Note 

@export var MissEffect : PackedScene = null
@export var OkEffect : PackedScene = null
@export var GreatEffect : PackedScene = null
@export var PerfectEffect : PackedScene = null

var noteSprite : Sprite2D = null
var myTween:Tween = null
var noteWasHit : bool = false
var myNoteType : GiftJamGlobals.NoteType = GiftJamGlobals.NoteType.UP 

# Called when the node enters the scene tree for the first time.
func _ready():
	noteSprite = $Sprite2D

func SetNoteType(type: GiftJamGlobals.NoteType):
	myNoteType = type

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
	
func ShowFeedback(NoteHitColor, EffectSpawned):
	#Sprite color is updated
	noteSprite.modulate = NoteHitColor
	#Spawned feedback's position is set to my position and added as a child of the globals
	EffectSpawned.global_position = global_position
	GiftJamGlobals.add_child(EffectSpawned)

func FadeAway(fadeDuration : float):
	if myTween and myTween.is_running():
		return
	myTween = self.create_tween().set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_IN)
	myTween.tween_property(self, "modulate:a", 0, fadeDuration)
