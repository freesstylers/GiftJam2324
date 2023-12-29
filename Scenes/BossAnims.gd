extends AnimatedSprite2D
var attackingMode : bool
var IdleAnim = preload("res://Assets/Sprites/Boss G/Animations/Idle.tres")
var PunchLeftAnim = preload("res://Assets/Sprites/Boss G/Animations/PunchLeft.tres")
var PunchRightAnim = preload("res://Assets/Sprites/Boss G/Animations/PunchRight.tres")
var PunchDownAnim = preload("res://Assets/Sprites/Protagonista/Animations/Ragnahilda_PunchDown.tres")
var PunchUpAnim = preload("res://Assets/Sprites/Protagonista/Animations/Ragnahilda_PunchUp.tres")

# Called when the node enters the scene tree for the first time.
func _ready():
	GiftJamGlobals.connect("Note_Hit_Result", on_note_hit_result)
	self.play()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.

func _on_base_battle_attack_mode_changed(attacking):
	attackingMode = attacking
	pass # Replace with function body.

func _on_animation_finished():
	self.set_sprite_frames(IdleAnim)
	self.play()
	pass # Replace with function body.

func on_note_hit_result(hitResult:GiftJamGlobals.NoteHitStatus, noteType : GiftJamGlobals.NoteType):
	if attackingMode:
		if hitResult == GiftJamGlobals.NoteHitStatus.PERFECT || hitResult == GiftJamGlobals.NoteHitStatus.GREAT || hitResult == GiftJamGlobals.NoteHitStatus.OK:
			var localTween : Tween = self.create_tween()
			localTween.set_trans(Tween.TRANS_LINEAR)
			localTween.set_ease(Tween.EASE_IN)
			var destColor : Color = Color(255.0,100.0/255.0,100.0/255.0)
			localTween.tween_property(self, "modulate", destColor, 0.1)
			localTween.tween_property(self, "modulate", Color.WHITE, 0.1)
			
			if hitResult == GiftJamGlobals.NoteHitStatus.PERFECT:
				GiftJamGlobals.LifeChanged.emit(GiftJamGlobals.characterHit.Enemy, 5)
				pass
			if hitResult == GiftJamGlobals.NoteHitStatus.GREAT:
				GiftJamGlobals.LifeChanged.emit(GiftJamGlobals.characterHit.Enemy, 4)
				pass
			if hitResult == GiftJamGlobals.NoteHitStatus.OK:
				GiftJamGlobals.LifeChanged.emit(GiftJamGlobals.characterHit.Enemy, 3)
				pass
	else:
		if noteType == GiftJamGlobals.NoteType.LEFT:
			self.set_sprite_frames(PunchLeftAnim)
			pass
		elif noteType == GiftJamGlobals.NoteType.RIGHT:
			self.set_sprite_frames(PunchRightAnim)
			pass
		elif noteType == GiftJamGlobals.NoteType.UP:
			pass
		elif noteType == GiftJamGlobals.NoteType.DOWN:
			pass
		pass
			
	
