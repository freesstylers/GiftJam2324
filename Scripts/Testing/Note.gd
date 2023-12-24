extends PathFollow2D
class_name Note 

@export var MissEffect : PackedScene = null
@export var OkEffect : PackedScene = null
@export var GreatEffect : PackedScene = null
@export var PerfectEffect : PackedScene = null

var noteSprite : Sprite2D = null
var myTween:Tween = null
var noteWasHit : bool = false
 
# Called when the node enters the scene tree for the first time.
func _ready():
	noteSprite = $Sprite2D

func GetNoteWasHit():
	return noteWasHit
	
func NoteHit(hitStatus : GiftJamGlobals.NoteHitStatus):
	if noteWasHit:
		return
	var noteHitColor : Color = Color.WHITE
	var hitEffectSpawned = null
	match hitStatus:
		GiftJamGlobals.NoteHitStatus.OK:
			noteHitColor = Color.ORANGE
			hitEffectSpawned = OkEffect.instantiate()
		GiftJamGlobals.NoteHitStatus.GREAT:
			noteHitColor = Color.YELLOW
			hitEffectSpawned = GreatEffect.instantiate()
		GiftJamGlobals.NoteHitStatus.PERFECT:
			noteHitColor = Color.GREEN
			hitEffectSpawned = PerfectEffect.instantiate()
		GiftJamGlobals.NoteHitStatus.MISS:
			noteHitColor = Color.RED
			hitEffectSpawned = MissEffect.instantiate()
	
	noteSprite.modulate = noteHitColor
	hitEffectSpawned.global_position = global_position
	GiftJamGlobals.add_child(hitEffectSpawned)
	noteWasHit = true

func FadeAway(fadeDuration : float):
	if myTween and myTween.is_running():
		return
	myTween = self.create_tween().set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_IN)
	myTween.tween_property(self, "modulate:a", 0, fadeDuration)
