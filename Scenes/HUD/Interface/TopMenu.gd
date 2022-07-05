extends CanvasLayer

onready var command_handler = get_node("CommandConsole/CommandHandler")

signal pause_game
signal shot_weapon
signal speed_changed(new_speed)
signal position_changed(new_position)
signal ray_power_changed(new_power)
signal ray_degree_changed(new_degree)

# si el input es válido
var P_valid := false
var D_valid := false
var S_valid := false

# mensaje a mostrar en label
var LaserText = "Constant Func"
var showLaser = true
var MFLaserText = "Parabolic Func"

var new_power

# Called when the node enters the scene tree for the first time.
func _ready():
	$ActualFunction.text = LaserText
	
	command_handler.connect("pause_game", self, "_on_CommandConsole_pause_game")
	
	command_handler.connect("pos_changed", self, "_on_CommandConsole_pos_changed")
	command_handler.connect("speed_changed", self, "_on_CommandConsole_speed_changed")
	
	command_handler.connect("shot_weapon", self, "_on_CommandConsole_shot_weapon")

	command_handler.connect("new_ray_speed", self, "_on_CommandConsole_new_ray_speed")
	command_handler.connect("new_ray_degree", self, "_on_CommandConsole_new_ray_degree")
	

func change_display() -> void:
	if showLaser:
		showLaser = false
		$ActualFunction.text = MFLaserText
	else:
		showLaser = true
		$ActualFunction.text = LaserText

func change_position(new_pos) -> void:
	$ControlMark/InformPosition/NumberPosition.text = String(int(new_pos))

func change_life(new_life) -> void:
	if new_life <= 35:
		$ControlMark/Life/LifeBar.get("custom_styles/fg").set_bg_color('8c1c13')
	elif new_life > 35:
		$ControlMark/Life/LifeBar.get("custom_styles/fg").set_bg_color('00cf0d')
	$ControlMark/Life/LifeBar.value = new_life

func change_speed_display() -> void:
	if $ControlMark/Speed.is_visible_in_tree():
		$ControlMark/Speed.hide()
	else:
		$ControlMark/Speed.show()

func _on_CommandConsole_pause_game():
	emit_signal("pause_game")

func _on_CommandConsole_pos_changed(new_position):
	emit_signal("position_changed", new_position)

func _on_CommandConsole_speed_changed(new_speed):
	$ControlMark/Speed/NumberSpeed.text = String(new_speed)
	emit_signal("speed_changed", new_speed)

func _on_CommandConsole_shot_weapon():
	emit_signal("shot_weapon")

func _on_CommandConsole_new_ray_speed(new_speed):
	emit_signal("ray_power_changed", new_speed)

func _on_CommandConsole_new_ray_degree(new_degree):
	emit_signal("ray_degree_changed", new_degree)
