extends CanvasLayer

onready var startmenu = get_node("StartMenu")

signal start_game

# Called when the node enters the scene tree for the first time.
func _ready():
	startmenu.connect("start_game", self, "_on_StartMenu_start_game")
	pass # Replace with function body.

func show_start_menu() -> void:
	$StartButton.show()
	$MessageLeft.show()
	$MessageRight.show()

func _on_StartButton_pressed():
	$StartButton.hide()
	$MessageLeft.hide()
	$MessageRight.hide()
	startmenu.show()
	

func _on_StartMenu_start_game():
	startmenu.hide()
	emit_signal("start_game")

