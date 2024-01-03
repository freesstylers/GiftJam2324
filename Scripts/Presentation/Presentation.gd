extends Control

@export var timer : float = 3.0
@export var spriteMain : AnimatedSprite2D = null
@export var spriteEnemy : AnimatedSprite2D = null
@export var vs : Node2D = null
@export var timeAnim : float = 2.0
@export var Enemy : GiftJamGlobals.Battle

@export var EnemyIdleAnim : SpriteFrames = null
@export var PlayerIdleAnim : SpriteFrames = null

# Called when the node enters the scene tree for the first time.
func _ready():
	start()
	pass
	
func start(time=timer):
	var t = $Timer
	start_animation()
	await t.timeout
	end()
	
func start_animation():
	spriteMain.play()
	spriteEnemy.play()
	
	var tween : Tween = spriteMain.create_tween()
	
	#Player and enemy animation
	tween.set_parallel(true)
	tween.set_trans(Tween.TRANS_LINEAR)
	tween.set_ease(Tween.EASE_IN)
	
	tween.tween_property(spriteMain, "position", Vector2(0.0, 227.5), timeAnim)
	###tween.tween_property(spriteEnemy, "position", Vector2(0.0, 0.0), timeAnim)
	tween.tween_property(vs, "scale", Vector2(1.0, 1.0), timeAnim)
	tween.tween_property(vs, "rotation", deg_to_rad(720.0), timeAnim)
	
func end():
	if Enemy == GiftJamGlobals.Battle.G:
		GiftJamGlobals.To_G_Battle.emit()
		pass
	elif Enemy == GiftJamGlobals.Battle.P:
		GiftJamGlobals.To_P_Battle.emit()
		pass
	#GiftJamGlobals.FromPresentationToBattle.emit()

func _on_Enemy_animation_finished():
	spriteEnemy.set_sprite_frames(EnemyIdleAnim)
	spriteEnemy.play()
	pass # Replace with function body.

func _on_Player_animation_finished():
	spriteMain.set_sprite_frames(PlayerIdleAnim)
	spriteMain.play()
	pass # Replace with function body.
