extends ProgressBar
class_name HealthBarController

@export var greyLifeUpdateSpeed : float = 10
var damageBar : ProgressBar = null
var greyLifeTimer : Timer = null
var greyLifeUpdating : bool = false

func _ready():
	damageBar = $DamageBar
	greyLifeTimer = $GreyLifeTimer
	value = max_value
	damageBar.max_value = max_value
	damageBar.value = value
	
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
	if auxLife < value:
		damageBar.value = value
	#Damage was taken
	else:
		greyLifeTimer.start()

func on_grey_life_timer_ended():
	greyLifeUpdating = true
