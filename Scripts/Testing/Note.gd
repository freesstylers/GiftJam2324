extends PathFollow2D

class_name Note

var noteSprite : Sprite2D = null

var myTween:Tween = null

# Called when the node enters the scene tree for the first time.
func _ready():
	noteSprite = $Sprite2D

func NoteHit(successfully : bool):
	if successfully:
		noteSprite.modulate = Color(0,1,0);
	else:
		noteSprite.modulate = Color(1,0,0);
	#Spawn something??? Visual effect???

func FadeAway(fadeDuration : float, dest : Vector2):
	myTween = self.create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	myTween.set_parallel(true)
	myTween.tween_property(self, "position", dest, fadeDuration)
	myTween.tween_property(self, "modulate:a", 0, fadeDuration)
	myTween.tween_callback(self.queue_free).set_delay(fadeDuration)
