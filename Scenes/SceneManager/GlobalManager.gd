extends Node2D

const sceneToload = preload("res://Scenes/BaseBattle.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#Gameplay Input sample
	if Input.is_action_just_pressed("input_left"):
		print("left")
		#send signal?
		pass
	elif Input.is_action_just_pressed("input_up"):
		print("up")
		#send signal?
		pass
	elif Input.is_action_just_pressed("input_down"):
		print("down")
		#send signal?
		pass
	elif Input.is_action_just_pressed("input_right"):
		print("right")
		#send signal?
		pass
		
	#Transition
	#if Input.is_action_just_pressed("ui_accept"):
		#$TransitionScreen.transition()
	pass

func startGame():
	$TransitionScreen.transition()

func _on_transition_screen_screen_transitioned():
	$CurrentScene.get_child(0).queue_free()
	$CurrentScene.add_child(sceneToload.instantiate())
	pass # Replace with function body.

