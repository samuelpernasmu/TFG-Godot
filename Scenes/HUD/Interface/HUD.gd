extends CanvasLayer

signal return_main
signal pause_game
signal shot_weapon
signal endgame
signal gameover
signal speed_changed(new_speed)
signal move_ship(new_pos)
signal change_power(new_power)
signal change_degree(new_degree)
signal intro_finished

onready var popup_pause = get_node("TopMenu/PopupCommandList")

var path_intro = str('res://Intros/intro_level_', GameHandler.level_data.level, '.txt')
var path_end = str('res://Intros/endgame.txt')
var intro_file = File.new()
var end_file = File.new()

func prepare_scene():
	$TopMenu/CommandConsole/inputPanel/input.editable = false
	var err = intro_file.open(path_intro, File.READ)
	if err != OK:
		printerr("Could not open file, error code ", err)
	$PopupIntro.popup()
	$PopupIntro/BG_Intro/Intro.text = str('Welcome to level ', GameHandler.level_data.level)

# Called when the node enters the scene tree for the first time.
func _ready():
	popup_pause.get_node("ClosePopup").pause_mode = 2
	popup_pause.get_node("MainMenu").pause_mode = 2

func _process(delta):
	$TopInterface/TextScore/Score.text = String(GameHandler.level_data.score)
	$TopInterface/TextTime/Time.text = String(GameHandler.level_data.time)

func show_line():
	var line = intro_file.get_line()
	$PopupIntro/BG_Intro/Intro.text = String(line)
	if intro_file.eof_reached():
		end_intro()

func show_end():
	var line = end_file.get_line()
	$PopupEnd/BG_end/End.text = String(line)
	if end_file.eof_reached():
		end()

func end_intro():
	$TopMenu/CommandConsole/inputPanel/input.editable = true
	intro_file.close()
	$PopupIntro/BG_Intro/Start.show()
	$PopupIntro/BG_Intro/Next.hide()

func end():
	end_file.close()
	$PopupEnd/BG_end/Finish.show()
	$PopupEnd/BG_end/Next.hide()

func write_level():
	$TopInterface/TextLevel/Level.text = String(GameHandler.level_data.level)
	prepare_scene()

func show_end_message(text) -> void:
	$PopupInfoMessage/InfoMessage.text = text
	$PopupInfoMessage.popup()
	$FinishTimer.start()

func show_final_message(text) -> void:
	$PopupInfoMessage/InfoMessage.text = text
	$PopupInfoMessage.popup()
	$MessageTimer.start()

func show_gameover_message(text) -> void:
	$PopupInfoMessage/InfoMessage.text = text
	$PopupInfoMessage.popup()
	$GameOverTimer.start()

func _on_MessageTimer_timeout():
	$PopupInfoMessage.hide()
	emit_signal("endgame")


func _on_GameOverTimer_timeout():
	$PopupInfoMessage.hide()
	emit_signal("gameover")


func _on_TopMenu_position_changed(new_position):
	emit_signal("move_ship", new_position)


func _on_TopMenu_degree_changed(new_degree):
	emit_signal("change_degree", new_degree)


func _on_TopMenu_power_changed(new_power):
	emit_signal("change_power", new_power)


func _on_ShipDefense_inform_position(new_position):
	$TopMenu.change_position(new_position)

func _on_ShipDefense_inform_life(new_life):
	$TopMenu.change_life(new_life)

func add_time(time):
	$TopInterface/TextTime/Time.text = String(time)

func add_points(points):
	$TopInterface/TextScore/Score.text = String(points)


func _on_ShipDefense_change_weapon():
	$TopMenu.change_display()


func _on_TopMenu_speed_changed(new_speed):
	emit_signal("speed_changed", new_speed)


func _on_TopMenu_shot_weapon():
	emit_signal("shot_weapon")


func _on_TopMenu_pause_game():
	emit_signal("pause_game")
	popup_pause.popup()


func _on_ClosePopup_pressed():
	emit_signal("pause_game")
	popup_pause.hide()


func _on_Start_pressed():
	$PopupIntro.hide()
	emit_signal('intro_finished')


func _on_MainMenu_pressed():
	emit_signal("return_main")




func _on_Finish_pressed():
	emit_signal("endgame")


func _on_FinishTimer_timeout():
	$PopupInfoMessage.hide()
	$PopupEnd.popup()
	var err = end_file.open(path_end, File.READ)
	if err != OK:
		printerr("Could not open file, error code ", err)
	$PopupEnd/BG_end/End.text = 'YOU DID IT!'
	$FinishTimer.stop()
