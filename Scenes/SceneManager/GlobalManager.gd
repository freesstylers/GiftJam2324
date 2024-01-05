extends Node2D

const introGScene = preload("res://Scenes/FinalContent/G_Presentation.tscn")
const introPScene = preload("res://Scenes/FinalContent/P_Presentation.tscn")
const introCScene = preload("res://Scenes/FinalContent/C_Presentation.tscn")
const battleGScene = preload("res://Scenes/FinalContent/G_Battle.tscn")
const battlePScene = preload("res://Scenes/FinalContent/P_Battle.tscn")
const battleCScene = preload("res://Scenes/FinalContent/C_Battle.tscn")
const menuScene = preload("res://Scenes/MainMenu.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	GiftJamGlobals.connect("To_G_Battle", Start_G_Battle)
	GiftJamGlobals.connect("To_P_Battle", Start_P_Battle)
	GiftJamGlobals.connect("To_C_Battle", Start_C_Battle)
	GiftJamGlobals.connect("To_P_Presentation", Start_P_Presentation)
	GiftJamGlobals.connect("FromBattleToMainMenu", End_Battle)
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
	

var currentLevel = -1

func startGame(level: int):
	$TransitionScreen.transition()
	currentLevel = level
	
func _on_transition_screen_screen_transitioned():
	match currentLevel:
		0:
			get_tree().root.get_node("SceneManager").Start_G_Presentation()
		1:
			get_tree().root.get_node("SceneManager").Start_P_Presentation()
		2:
			get_tree().root.get_node("SceneManager").Start_C_Presentation()
	currentLevel = -1
	pass # Replace with function body.

func Start_G_Presentation():
	$CurrentScene.get_child(0).queue_free()
	$CurrentScene.add_child(introGScene.instantiate())
	pass # Replace with function body.


func Start_G_Battle():
	$CurrentScene.get_child(0).queue_free()
	$CurrentScene.add_child(battleGScene.instantiate())
	
func Start_P_Presentation():
	$CurrentScene.get_child(0).queue_free()
	$CurrentScene.add_child(introPScene.instantiate())
	
func Start_P_Battle():
	$CurrentScene.get_child(0).queue_free()
	$CurrentScene.add_child(battlePScene.instantiate())
	
func Start_C_Presentation():
	$CurrentScene.get_child(0).queue_free()
	$CurrentScene.add_child(introCScene.instantiate())
	
func Start_C_Battle():
	$CurrentScene.get_child(0).queue_free()
	$CurrentScene.add_child(battleCScene.instantiate())
	
func End_Battle():
	$CurrentScene.get_child(0).queue_free()
	$CurrentScene.add_child(menuScene.instantiate())
