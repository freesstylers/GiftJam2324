extends AnimatedSprite2D

var attackingMode : bool
var IdleAnim = preload("res://Assets/Sprites/Protagonista/Animations/Ragnahilda_Idle.tres")
var PunchLeftAnim = preload("res://Assets/Sprites/Protagonista/Animations/Ragnahilda_PunchLeft.tres")
var PunchRightAnim = preload("res://Assets/Sprites/Protagonista/Animations/Ragnahilda_PunchRight.tres")
var PunchDownAnim = preload("res://Assets/Sprites/Protagonista/Animations/Ragnahilda_PunchDown.tres")
var PunchUpAnim = preload("res://Assets/Sprites/Protagonista/Animations/Ragnahilda_PunchUp.tres")
# Called when the node enters the scene tree for the first time.
func _ready():
	GiftJamGlobals.connect("Note_Hit_Result", on_note_hit_result)
	self.play()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if attackingMode:
		if Input.is_action_just_pressed("input_right"):
			self.set_sprite_frames(PunchRightAnim)
			self.play()
		if Input.is_action_just_pressed("input_left"):
			self.set_sprite_frames(PunchLeftAnim)
			self.play()
		if Input.is_action_just_pressed("input_up"):
			self.set_sprite_frames(PunchUpAnim)
			self.play()
		if Input.is_action_just_pressed("input_down"):
			self.set_sprite_frames(PunchDownAnim)
			self.play()
	else:		
		if Input.is_action_just_pressed("input_right"):
			self.set_sprite_frames(PunchRightAnim)
			self.play()
		if Input.is_action_just_pressed("input_left"):
			self.set_sprite_frames(PunchLeftAnim)
			self.play()
		if Input.is_action_just_pressed("input_up"):
			self.set_sprite_frames(PunchUpAnim)
			self.play()
		if Input.is_action_just_pressed("input_down"):
			self.set_sprite_frames(PunchDownAnim)
			self.play()

func _on_base_battle_attack_mode_changed(attacking):
	attackingMode = attacking
	pass # Replace with function body.

func _on_animation_finished():
	self.set_sprite_frames(IdleAnim)
	self.play()
	pass # Replace with function body.

func on_note_hit_result(hitResult:GiftJamGlobals.NoteHitStatus, noteType : GiftJamGlobals.NoteType):
	var localTween : Tween = self.create_tween()
	localTween.set_trans(Tween.TRANS_LINEAR)
	localTween.set_ease(Tween.EASE_IN)
	var destColor : Color = Color(255.0,100.0/255.0,100.0/255.0)
	localTween.tween_property(self, "modulate", destColor, 0.1)
	localTween.tween_property(self, "modulate", Color.WHITE, 0.1)
	pass
