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

func _on_play_button_down():
	get_tree().root.get_node("SceneManager").startGame()
	pass # Replace with function body.

func _on_credits_button_down():
	get_node("CreditsPanel").visible = true
	pass # Replace with function body.

func _on_credits_back_button_down():
	get_node("CreditsPanel").visible = false
	pass # Replace with function body.
