extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.


func FreeStylers():
	OS.shell_open("https://freestylers-studio.itch.io/")
	pass # Replace with function body.

func Jam():
	OS.shell_open("https://itch.io/jam/gift-jam-2023")
	pass # Replace with function body.

func Twitter():
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
	get_tree().root.get_node("SceneManager").startGame()
	pass # Replace with function body.

func _on_credits_button_down():
	get_node("CreditsPanel").visible = true
	$"MainButtonContainer".visible = false;
	pass # Replace with function body.

func _on_credits_back_button_down():
	get_node("CreditsPanel").visible = false
	$"MainButtonContainer".visible = true;
	pass # Replace with function body.


func TogglePlayMenu(state: bool):
	$"level container".visible = state;
	$"MainButtonContainer".visible = not state;
	pass # Replace with function body.
