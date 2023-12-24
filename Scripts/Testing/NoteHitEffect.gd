extends Node2D

@export var FadeDuration : float = 3
@export var MovementDelta : Vector2 = Vector2(0,-100)

var myTween : Tween = null

func _ready():
	myTween = self.create_tween().set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT);
	myTween.set_parallel(true)
	myTween.tween_property(self, "position", self.global_position + MovementDelta, FadeDuration)
	myTween.tween_property(self, "modulate:a", 0, FadeDuration)
	myTween.tween_callback(self.queue_free).set_delay(FadeDuration)
