extends ProgressBar
class_name HealthBarController

@export var greyLifeUpdateSpeed : float = 10
@export var onHitDisplacement : Vector2 = Vector2(5,-5)
var damageBar : ProgressBar = null
var greyLifeTimer : Timer = null
var greyLifeUpdating : bool = false
var barOriginalPos : Vector2 = Vector2()

func _ready():
	damageBar = $DamageBar
	greyLifeTimer = $GreyLifeTimer
	value = max_value
	damageBar.max_value = max_value
	damageBar.value = value
	damageBar.fill_mode = fill_mode
	barOriginalPos = position
	
func _process(delta):
	if greyLifeUpdating:
		damageBar.value -= (greyLifeUpdateSpeed*delta)
		if damageBar.value < value:
			damageBar.value = value
			greyLifeUpdating = false
	
func SetLife(newVal):
	var auxLife = value
	value = min(max_value, newVal)
	greyLifeUpdating=false
	greyLifeTimer.stop()
	#More life was added
	if auxLife <= value:
		damageBar.value = value
	#Damage was taken
	else:
		greyLifeTimer.start()
		var localTween : Tween = self.create_tween()
		localTween.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		localTween.tween_property(self, "position", barOriginalPos + onHitDisplacement, 0.1)
		localTween.tween_property(self, "position", barOriginalPos, 0.1)

func on_grey_life_timer_ended():
	greyLifeUpdating = true
