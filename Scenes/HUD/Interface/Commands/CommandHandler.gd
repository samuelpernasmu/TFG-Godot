extends Node

signal ray_degree_changed(new_degree)
signal ray_speed_changed(new_speed)
signal pos_changed(new_position)
signal speed_changed(new_speed)
signal shot_weapon
signal pause_game

enum {
	ARG_INT,
	ARG_STRING,
	ARG_FLOAT,
	ARG_BOOL
}

var enable_speed = false
var enable_mflaser = false
var enable_macro = false

# Lista de comandos: Nombre, ¿macro?, [arg 1, arg2, ...]
var valid_commands = []
#	["macro",
#		false,
#		[]],
#	["pause",
#		false,
#		[]],
#	["move",
#		false,
#		[ARG_FLOAT]],
#	["shot", 
#		false, 
#		[]],
#	["delete",
#		false,
#		[ARG_STRING]],
#	["ray_speed",
#		false,
#		[ARG_INT]],
#	["ray_degree",
#		false,
#		[ARG_INT]],
#	["speed",
#		false,
#		[ARG_INT]]


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func check_enable(command_name):
	match command_name:
		'speed':
			return enable_speed
		'ray_degree':
			return enable_mflaser
		'ray_speed':
			return enable_mflaser
		'macro':
			return enable_macro
		'delete':
			return enable_macro
		_:
			return true

func move(new_pos):
	var pos = int(new_pos)
	emit_signal("pos_changed", pos)
	return str('Move ship: ', pos)

func shot(nothing):
	emit_signal("shot_weapon")
	return('Shot weapon')

func ray_speed(new_speed):
	var speed = int(new_speed)
	emit_signal("ray_speed_changed", speed)
	return str('New ray speed: ', speed)

func ray_degree(new_degree):
	var degree = int(new_degree)
	if degree > 90 or degree <= 0:
		return str("Error: Ray degree must be between 0º and 90º.")
	emit_signal("ray_degree_changed", degree)
	return str('New ray degree: ', degree)

func speed(new_speed):
	var speed = int(new_speed)
	if speed < 1:
		return str("Error: New speed must be over 1.")
	if speed > 300:
		return str("Error: New speed must not be over 300.")
	emit_signal("speed_changed", speed)
	return str('New ship speed: ', speed)
	

func pause(nothing):
	emit_signal("pause_game")
	return 'Paused the game'

func macro(words):
	if words.empty():
		return 'Macro\'s name missing'
	
	# primer elemento es el nombre de la macro
	var macro_name = words.pop_front()
	var pos = get_parent().get_pos_macro(macro_name)
	
	var macro = [macro_name, true]
	var commands = []
	
	while(!words.empty()):
		var command_word = words.pop_front()
		
		for c in valid_commands:
			# puede almacenar comando u otras macros
			if c[0] == command_word:
				var argument
				# si es un comando
				if !c[1]:
					# si no tiene argumentos el comando
					if c[2].empty():
						argument = null
					# si tiene argumentos
					else:
						argument = words.pop_front()
						if argument == null:
							return 'Missing argument'
							return
						if not get_parent().check_type(argument, c[2][0]):
							return (str('Failure adding command "', command_word, '", parameter ', (0 + 1),
							' ("', argument, '") is of the wrong type"' ))
							return
					commands.append_array([[command_word, argument]])
				# si es una macro
				else:
					# almacenamos las llamadas de comandos de forma consecutiva
					commands.append_array(c[2])
	if commands.empty():
		return 'No commands provided'
	
	macro.append_array([commands])
	valid_commands.remove(pos)
	valid_commands.push_back(macro)
	get_parent().macro_output_text()
	return 'Macro created successfully!'


func delete(macro_name):
	var pos = get_parent().get_pos_macro(macro_name)
	valid_commands.remove(pos)
	get_parent().macro_output_text()
	return str('Macro ', macro_name, ' deleted successfully!')


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
