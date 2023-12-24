extends PathFollow2D

class_name Note

@export var MissEffect : PackedScene = null
@export var OkEffect : PackedScene = null
@export var GreatEffect : PackedScene = null
@export var PerfectEffect : PackedScene = null

var noteSprite : Sprite2D = null
var myTween:Tween = null
var hitDone : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	noteSprite = $Sprite2D

func NoteHit(successfully:bool):
	if hitDone:
		return
		
	if successfully:
		noteSprite.modulate = Color(0,1,0);
		var effectInstance = PerfectEffect.instantiate()
		effectInstance.global_position = global_position
		GiftJamGlobals.add_child(effectInstance)
	else:
		noteSprite.modulate = Color(1,0,0);
	#Spawn something??? Visual effect???
	hitDone = true

func FadeAway(fadeDuration : float):
	if myTween and myTween.is_running():
		return
	myTween = self.create_tween().set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_IN)
	myTween.tween_property(self, "modulate:a", 0, fadeDuration)
