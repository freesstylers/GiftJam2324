extends AnimatedSprite2D

@export var TakeDamagePositionDelta : Vector2 = Vector2(0,10)

var attackingMode : bool = true
var IdleAnim = preload("res://Assets/Sprites/Protagonista/Animations/Ragnahilda_Idle.tres")
var PunchLeftAnim = preload("res://Assets/Sprites/Protagonista/Animations/Ragnahilda_PunchLeft.tres")
var PunchRightAnim = preload("res://Assets/Sprites/Protagonista/Animations/Ragnahilda_PunchRight.tres")
var PunchDownAnim = preload("res://Assets/Sprites/Protagonista/Animations/Ragnahilda_PunchDown.tres")
var PunchUpAnim = preload("res://Assets/Sprites/Protagonista/Animations/Ragnahilda_PunchUp.tres")
var EvadeBackAnim = preload("res://Assets/Sprites/Protagonista/Animations/Ragnahilda_EvadeBack.tres")
var EvadeLeftAnim = preload("res://Assets/Sprites/Protagonista/Animations/Ragnahilda_EvadeLeft.tres")

var playerOriginalPos : Vector2 = Vector2(0,0)
var playerOriginalScale : Vector2 = Vector2(0,0)

var animTween : Tween = null

# Called when the node enters the scene tree for the first time.
func _ready():
	GiftJamGlobals.connect("Note_Hit_Result", on_note_hit_result)
	self.play()
	playerOriginalPos = global_position
	playerOriginalScale = scale

func _on_base_battle_attack_mode_changed(attacking):
	attackingMode = attacking

func _on_animation_finished():
	global_position = playerOriginalPos
	scale = playerOriginalScale
	self.set_sprite_frames(IdleAnim)
	self.play()

func on_note_hit_result(hitResult:GiftJamGlobals.NoteHitStatus, noteType : GiftJamGlobals.NoteType):
	if attackingMode:
		#Stop a possible running tween, just assigning a new tween does not stop the old one
		if animTween and animTween.is_running():
			animTween.stop()
		animTween = self.create_tween()
		animTween.set_trans(Tween.TRANS_QUART)
		animTween.set_ease(Tween.EASE_OUT)
		
		var animLength : float = 0.4
		global_position = playerOriginalPos
		#Only play a hit animation if the player hit the punch note correctly
		if hitResult != GiftJamGlobals.NoteHitStatus.MISS:
			#Stop the current anim (just in case) and play a new one based on the input
			self.stop()
			if noteType == GiftJamGlobals.NoteType.LEFT:
				self.set_sprite_frames(PunchLeftAnim)
				animTween.tween_property(self, "position", playerOriginalPos + Vector2(0, -35), animLength)
			elif noteType == GiftJamGlobals.NoteType.RIGHT:
				global_position = playerOriginalPos + Vector2(0,-60)
				self.set_sprite_frames(PunchRightAnim)
				animTween.tween_property(self, "position", playerOriginalPos + Vector2(0,-60) + Vector2(0, -15), animLength)
			elif noteType == GiftJamGlobals.NoteType.UP:
				global_position = playerOriginalPos + Vector2(0,-60)
				self.set_sprite_frames(PunchUpAnim)
				animTween.tween_property(self, "position", playerOriginalPos + Vector2(0,-60) + Vector2(0, -15), animLength)
			elif noteType == GiftJamGlobals.NoteType.DOWN:
				self.set_sprite_frames(PunchDownAnim)
				#animTween.set_trans(Tween.TRANS_LINEAR)
				#animTween.set_ease(Tween.EASE_IN)
				#animTween.set_parallel(true)
				#animTween.tween_property(self, "scale", playerOriginalScale*1.2, animLength)
				#animTween.tween_property(self, "position", playerOriginalPos + Vector2(0, -80), animLength)
			self.play()
			
			$HitPlayer.play()
		else:
			$MissPlayer.play()
	else:
		var animLength : float = 0.2
		animTween = self.create_tween()
		#Player FAILED, takes damage and make some tween animation 
		if hitResult == GiftJamGlobals.NoteHitStatus.MISS || hitResult == GiftJamGlobals.NoteHitStatus.NONE:
			animTween.set_trans(Tween.TRANS_LINEAR)
			animTween.set_ease(Tween.EASE_IN)
			animTween.set_parallel(true)
			#Color anim (player turns red for a brief moment and goes back to normal color)
			animTween.tween_property(self, "modulate", Color(1.0,100.0/255.0,100.0/255.0), animLength/2.0)
			animTween.tween_property(self, "modulate", Color.WHITE, animLength/2.0).set_delay(animLength/2.0)
			#Position anim (player is moved from its position to simulate the hit impact)
			global_position = playerOriginalPos
			animTween.tween_property(self, "position", playerOriginalPos + Vector2(0, -18), animLength/2.0)
			animTween.tween_property(self, "position", playerOriginalPos , animLength/2.0).set_delay(animLength/2.0)
			#Scale the player to simulate the hit
			scale = playerOriginalScale
			animTween.tween_property(self, "scale", playerOriginalScale*1.1, animLength/2.0)
			animTween.tween_property(self, "scale", playerOriginalScale, animLength/2.0).set_delay(animLength/2.0)
			#Send signal to notify that the player should lose some health
			if hitResult == GiftJamGlobals.NoteHitStatus.NONE:
				GiftJamGlobals.LifeChanged.emit(GiftJamGlobals.characterHit.Ragnahilda, 5)
			if hitResult == GiftJamGlobals.NoteHitStatus.MISS:
				GiftJamGlobals.LifeChanged.emit(GiftJamGlobals.characterHit.Ragnahilda, 4)
				
			$HitPlayer.play()
		#Player defended succesfully??? Do an evasion anim
		else:
			global_position = playerOriginalPos
			self.stop()
			if noteType == GiftJamGlobals.NoteType.LEFT:
				animTween.set_trans(Tween.TRANS_QUINT)
				animTween.set_ease(Tween.EASE_IN)
				self.set_sprite_frames(EvadeLeftAnim)
				animTween.tween_property(self, "position", playerOriginalPos + Vector2(-60, 0), animLength)
				animTween.tween_property(self, "position", playerOriginalPos , 0)
				
			elif noteType == GiftJamGlobals.NoteType.RIGHT:
				self.scale.x = -playerOriginalScale.x
				self.set_sprite_frames(EvadeLeftAnim)
				animTween.tween_property(self, "position", playerOriginalPos + Vector2(60, 0), animLength)
				animTween.tween_property(self, "position", playerOriginalPos , 0)

			elif noteType == GiftJamGlobals.NoteType.UP:
				scale = playerOriginalScale	
				self.set_sprite_frames(EvadeBackAnim)
				animTween.set_trans(Tween.TRANS_LINEAR)
				animTween.set_ease(Tween.EASE_IN)
				animTween.set_parallel(true)
				animTween.tween_property(self, "scale", playerOriginalScale*0.9, animLength)
				animTween.tween_property(self, "scale", playerOriginalScale, 0)
				animTween.tween_property(self, "position", playerOriginalPos + Vector2(0, 18), animLength)
				animTween.tween_property(self, "position", playerOriginalPos , 0)

			elif noteType == GiftJamGlobals.NoteType.DOWN:
				scale = playerOriginalScale
				self.set_sprite_frames(EvadeBackAnim)
				animTween.set_trans(Tween.TRANS_LINEAR)
				animTween.set_ease(Tween.EASE_IN)
				animTween.set_parallel(true)
				animTween.tween_property(self, "scale", playerOriginalScale*1.2, animLength)
				animTween.tween_property(self, "scale", playerOriginalScale, 0)
				animTween.tween_property(self, "position", playerOriginalPos + Vector2(0, -30), animLength)
				animTween.tween_property(self, "position", playerOriginalPos , 0)
			self.play()
			
			$MissPlayer.play()
