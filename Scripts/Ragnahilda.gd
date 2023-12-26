extends AnimatedSprite2D

var attackingMode : bool
var IdleAnim = preload("res://Assets/Sprites/Protagonista/Animations/Ragnahilda_Idle.tres")
var PunchLeftAnim = preload("res://Assets/Sprites/Protagonista/Animations/Ragnahilda_PunchLeft.tres")
var PunchRightAnim = preload("res://Assets/Sprites/Protagonista/Animations/Ragnahilda_PunchRight.tres")
var PunchDownAnim = preload("res://Assets/Sprites/Protagonista/Animations/Ragnahilda_PunchDown.tres")
# Called when the node enters the scene tree for the first time.
func _ready():
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
			pass
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
			pass
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
