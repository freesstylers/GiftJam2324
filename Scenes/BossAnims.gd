extends AnimatedSprite2D
var attackingMode : bool

@export var IdleAnim : SpriteFrames = null
@export var PunchLeftAnim : SpriteFrames = null
@export var PunchRightAnim : SpriteFrames = null
@export var PunchDownAnim : SpriteFrames = null
@export var PunchUpAnim : SpriteFrames = null

# Called when the node enters the scene tree for the first time.
func _ready():
	GiftJamGlobals.connect("Note_Hit_Result", on_note_hit_result)
	self.play()

func _on_base_battle_attack_mode_changed(attacking):
	attackingMode = attacking

func _on_animation_finished():
	self.set_sprite_frames(IdleAnim)
	self.play()

func on_note_hit_result(hitResult:GiftJamGlobals.NoteHitStatus, noteType : GiftJamGlobals.NoteType):
	#Is the player currently attacking???
	if attackingMode:
		if hitResult == GiftJamGlobals.NoteHitStatus.PERFECT || hitResult == GiftJamGlobals.NoteHitStatus.GREAT || hitResult == GiftJamGlobals.NoteHitStatus.OK:
			var localTween : Tween = self.create_tween()
			localTween.set_trans(Tween.TRANS_LINEAR)
			localTween.set_ease(Tween.EASE_IN)
			localTween.tween_property(self, "modulate", Color(1.0,100.0/255.0,100.0/255.0), 0.1)
			localTween.tween_property(self, "modulate", Color.WHITE, 0.1)
			
			if hitResult == GiftJamGlobals.NoteHitStatus.PERFECT:
				GiftJamGlobals.LifeChanged.emit(GiftJamGlobals.characterHit.Enemy, 5)
				pass
			elif hitResult == GiftJamGlobals.NoteHitStatus.GREAT:
				GiftJamGlobals.LifeChanged.emit(GiftJamGlobals.characterHit.Enemy, 4)
				pass
			elif hitResult == GiftJamGlobals.NoteHitStatus.OK:
				GiftJamGlobals.LifeChanged.emit(GiftJamGlobals.characterHit.Enemy, 3)
				pass
			else:
				#Tween guapo
				pass
	#Is the boss's turn to attack???
	else:
		#Stop whatever the boss is doing and play an animation that matches the note type
		self.stop()
		if noteType == GiftJamGlobals.NoteType.LEFT:
			self.set_sprite_frames(PunchLeftAnim)
		elif noteType == GiftJamGlobals.NoteType.RIGHT:
			self.set_sprite_frames(PunchRightAnim)
		elif noteType == GiftJamGlobals.NoteType.UP:
			self.set_sprite_frames(PunchUpAnim)
		elif noteType == GiftJamGlobals.NoteType.DOWN:
			self.set_sprite_frames(PunchDownAnim)
		self.play()
