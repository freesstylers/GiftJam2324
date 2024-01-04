extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.


func FreeStylers():
	$ButtonSFX.play()
	OS.shell_open("https://freestylers-studio.itch.io/")
	pass # Replace with function body.

func Jam():
	$ButtonSFX.play()
	OS.shell_open("https://itch.io/jam/gift-jam-2023")
	pass # Replace with function body.

func Twitter():
	$ButtonSFX.play()
	OS.shell_open("https://twitter.com/FreeStylers_Dev")
	pass # Replace with function body.


func _on_free_stylers_button_down():
	FreeStylers()
	pass # Replace with function body.


func _on_gift_jam_button_down():
	Jam()
	pass # Replace with function body.


func _on_twitter_button_down():
	Twitter()
	pass # Replace with function body.

func _on_level_button_down(level: int):
	$ButtonSFX.play()
	get_tree().root.get_node("SceneManager").startGame()
	pass # Replace with function body.

func _on_credits_button_down():
	$ButtonSFX.play()
	get_node("credits").visible = true
	$"MainButtonContainer".visible = false;
	pass # Replace with function body.

func _on_credits_back_button_down():
	$ButtonSFX.play()
	get_node("credits").visible = false
	$"MainButtonContainer".visible = true;
	pass # Replace with function body.

func TogglePlayMenu(state: bool):
	$ButtonSFX.play()
	$"level container".visible = state;
	$"MainButtonContainer".visible = not state;
	pass # Replace with function body.


func _on_tutorial_button_down():
	$ButtonSFX.play()
	get_node("tutorial").visible = true
	$"MainButtonContainer".visible = false;
	pass # Replace with function body.

func _on_tutorial_back_button_down():
	$ButtonSFX.play()
	get_node("tutorial").visible = false
	$"MainButtonContainer".visible = true;
	pass # Replace with function body.
