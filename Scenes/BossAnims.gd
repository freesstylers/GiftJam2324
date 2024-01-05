extends AnimatedSprite2D
var attackingMode : bool

@export var IdleAnim : SpriteFrames = null
@export var PunchLeftAnim : SpriteFrames = null
@export var PunchRightAnim : SpriteFrames = null
@export var PunchDownAnim : SpriteFrames = null
@export var PunchUpAnim : SpriteFrames = null

var battleType : GiftJamGlobals.Battle = GiftJamGlobals.Battle.P

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
				GiftJamGlobals.LifeChanged.emit(GiftJamGlobals.characterHit.Enemy, GetNoteHitDamageReceived(GiftJamGlobals.NoteHitStatus.PERFECT))
				pass
			elif hitResult == GiftJamGlobals.NoteHitStatus.GREAT:
				GiftJamGlobals.LifeChanged.emit(GiftJamGlobals.characterHit.Enemy, GetNoteHitDamageReceived(GiftJamGlobals.NoteHitStatus.GREAT))
				pass
			elif hitResult == GiftJamGlobals.NoteHitStatus.OK:
				GiftJamGlobals.LifeChanged.emit(GiftJamGlobals.characterHit.Enemy, GetNoteHitDamageReceived(GiftJamGlobals.NoteHitStatus.OK))
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
		
func GetNoteHitDamageReceived(hitResult: GiftJamGlobals.NoteHitStatus) -> int:
	if battleType == GiftJamGlobals.Battle.G:
		if hitResult == GiftJamGlobals.NoteHitStatus.PERFECT:
			return 4
		elif hitResult == GiftJamGlobals.NoteHitStatus.GREAT:
			return 3
		elif hitResult == GiftJamGlobals.NoteHitStatus.OK:
			return 2
	if battleType == GiftJamGlobals.Battle.P:
		if hitResult == GiftJamGlobals.NoteHitStatus.PERFECT:
			return 7
		elif hitResult == GiftJamGlobals.NoteHitStatus.GREAT:
			return 6
		elif hitResult == GiftJamGlobals.NoteHitStatus.OK:
			return 5
	return 0
	
