extends Control

signal start_game

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var enable_arcade = false

# Called when the node enters the scene tree for the first time.
func _ready():
	if enable_arcade:
		$Arcade.text = "Arcade"
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_NewGame_pressed():
	GameHandler.new_game()
	emit_signal("start_game")

func _on_Continue_pressed():
	emit_signal("start_game")

func _on_Arcade_pressed():
	if !enable_arcade:
		$Arcade/ArcadeDisabled.popup()


func _on_Settings_pressed():
	$Settings/ShowSettings.popup()


func _on_ShowResults_pressed():
	for s in GameHandler.scores:
		if s[1] != 0:
			$PopupShowResults/RowLevel.text += str(s[0], '\n')
			$PopupShowResults/RowScore.text += str(s[1], '\n')
			$PopupShowResults/RowTime.text += str(s[2], '\n')
	$PopupShowResults.popup()


