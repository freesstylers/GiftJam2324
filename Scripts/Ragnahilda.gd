extends AnimatedSprite2D

@export var TakeDamagePositionDelta : Vector2 = Vector2(0,10)

var attackingMode : bool = true
var IdleAnim = preload("res://Assets/Sprites/Protagonista/Animations/Ragnahilda_Idle.tres")
var PunchLeftAnim = preload("res://Assets/Sprites/Protagonista/Animations/Ragnahilda_PunchLeft.tres")
var PunchRightAnim = preload("res://Assets/Sprites/Protagonista/Animations/Ragnahilda_PunchRight.tres")
var PunchDownAnim = preload("res://Assets/Sprites/Protagonista/Animations/Ragnahilda_PunchDown.tres")
var PunchUpAnim = preload("res://Assets/Sprites/Protagonista/Animations/Ragnahilda_PunchUp.tres")
var EvadeSidewaysAnim = preload("res://Assets/Sprites/Protagonista/Animations/Ragnahilda_EvadeSideways.tres")
var EvadeBackAnim = preload("res://Assets/Sprites/Protagonista/Animations/Ragnahilda_EvadeBack.tres")

var playerOriginalPos : Vector2 = Vector2(0,0)

# Called when the node enters the scene tree for the first time.
func _ready():
	GiftJamGlobals.connect("Note_Hit_Result", on_note_hit_result)
	self.play()
	playerOriginalPos = global_position

func _on_base_battle_attack_mode_changed(attacking):
	attackingMode = attacking

func _on_animation_finished():
	self.set_sprite_frames(IdleAnim)
	self.play()

func on_note_hit_result(hitResult:GiftJamGlobals.NoteHitStatus, noteType : GiftJamGlobals.NoteType):
	if attackingMode:
		#Only play a hit animation if the player hit the punch note correctly
		if hitResult != GiftJamGlobals.NoteHitStatus.MISS:
			#Stop the current anim (just in case) and play a new one based on the input
			self.stop()
			if noteType == GiftJamGlobals.NoteType.LEFT:
				self.set_sprite_frames(PunchLeftAnim)
				self.play()
			elif noteType == GiftJamGlobals.NoteType.RIGHT:
				self.set_sprite_frames(PunchRightAnim)
				self.play()
			elif noteType == GiftJamGlobals.NoteType.UP:
				self.set_sprite_frames(PunchUpAnim)
				self.play()
			elif noteType == GiftJamGlobals.NoteType.DOWN:
				self.set_sprite_frames(PunchDownAnim)
				self.play()
	else:
		var animLength : float = 0.0
		var defenseTween : Tween = self.create_tween()
		#Player FAILED, takes damage and make some tween animation 
		if hitResult == GiftJamGlobals.NoteHitStatus.MISS || hitResult == GiftJamGlobals.NoteHitStatus.NONE:
			defenseTween.set_trans(Tween.TRANS_LINEAR)
			defenseTween.set_ease(Tween.EASE_IN)
			animLength = 0.2
			defenseTween.set_parallel(true)
			#Color anim (player turns red for a brief moment and goes back to normal color)
			defenseTween.tween_property(self, "modulate", Color(1.0,100.0/255.0,100.0/255.0), animLength/2.0)
			defenseTween.tween_property(self, "modulate", Color.WHITE, animLength/2.0).set_delay(animLength/2.0)
			#Position anim (player is moved from its position to simulate the hit impact)
			global_position = playerOriginalPos
			defenseTween.tween_property(self, "position", playerOriginalPos + TakeDamagePositionDelta, animLength/2.0)
			defenseTween.tween_property(self, "position", playerOriginalPos , animLength/2.0).set_delay(animLength/2.0)
			#Send signal to notify that the player should lose some health
			if hitResult == GiftJamGlobals.NoteHitStatus.NONE:
				GiftJamGlobals.LifeChanged.emit(GiftJamGlobals.characterHit.Ragnahilda, 5)
			if hitResult == GiftJamGlobals.NoteHitStatus.MISS:
				GiftJamGlobals.LifeChanged.emit(GiftJamGlobals.characterHit.Ragnahilda, 4)
		#Player defended succesfully??? Do an evasion anim
		else:
			animLength = 0.2
			var evadeDisplacement : Vector2 = Vector2(0,0)
			global_position = playerOriginalPos
			if noteType == GiftJamGlobals.NoteType.LEFT:
				defenseTween.set_trans(Tween.TRANS_QUINT)
				defenseTween.set_ease(Tween.EASE_IN)
				evadeDisplacement = Vector2(-20, 10)
				self.stop()
				self.set_sprite_frames(EvadeSidewaysAnim)
				self.play()
			elif noteType == GiftJamGlobals.NoteType.RIGHT:
				evadeDisplacement = Vector2(20, 10)
				self.stop()
				self.set_sprite_frames(EvadeSidewaysAnim)
				self.play()
				pass
			elif noteType == GiftJamGlobals.NoteType.UP:
				defenseTween.set_trans(Tween.TRANS_LINEAR)
				defenseTween.set_ease(Tween.EASE_IN)
				evadeDisplacement = Vector2(0, 30)
				self.stop()
				self.set_sprite_frames(EvadeBackAnim)
				self.play()
				pass
			elif noteType == GiftJamGlobals.NoteType.DOWN:
				defenseTween.set_trans(Tween.TRANS_LINEAR)
				defenseTween.set_ease(Tween.EASE_IN)
				evadeDisplacement = Vector2(0, 30)
				self.stop()
				self.set_sprite_frames(EvadeBackAnim)
				self.play()
				pass
			defenseTween.tween_property(self, "position", playerOriginalPos + evadeDisplacement, animLength)
			defenseTween.tween_property(self, "position", playerOriginalPos , 0)
