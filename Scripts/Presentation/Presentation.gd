extends Control

@export var timer : float = 3.0
@export var spriteMain : AnimatedSprite2D = null
@export var spriteEnemy : AnimatedSprite2D = null
@export var vs : Node2D = null
@export var timeAnim : float = 2.0

signal end_presentation

# Called when the node enters the scene tree for the first time.
func _ready():
	start()
	pass
	
func start(time=timer):
	var t = Timer.new()
	t.one_shot = true
	t.wait_time = time
	start_animation()
	#t.process_callback = end
	
func start_animation():
	spriteMain.play()
	spriteEnemy.play()
	
	var tween : Tween = spriteMain.create_tween()
	
	#Player and enemy animation
	tween.set_parallel(true)
	tween.set_trans(Tween.TRANS_LINEAR)
	tween.set_ease(Tween.EASE_IN)
	tween.tween_property(spriteMain, "position", Vector2(0.0, 0.0), timeAnim)
	tween.tween_property(spriteEnemy, "position", Vector2(0.0, 0.0), timeAnim)
	tween.tween_property(vs, "scale", Vector2(1.0, 1.0), timeAnim)
	tween.tween_property(vs, "rotation", deg_to_rad(720.0), timeAnim)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func end():
	end_presentation.emit()
