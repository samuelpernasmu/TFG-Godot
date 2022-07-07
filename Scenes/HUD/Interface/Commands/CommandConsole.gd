extends Control

onready var input_box = get_node("inputPanel/input")
onready var output_box = get_node("output")

onready var macro_input = get_node("macroPanel/macroInput")
onready var macro_output = get_node("MacroOutput")

onready var command_handler = get_node("CommandHandler")

# Called when the node enters the scene tree for the first time.
func _ready():
	input_box.grab_focus()

func save_commands():
	var save_dict = {
		"commands" : command_handler.valid_commands
	}
	return save_dict

func load_commands(commands):
	command_handler.valid_commands = commands
	macro_output_text()

func process_command(text):
	var words = text.split(" ")
	words = Array(words)
	
	# si ponemos un esacio en blanco antes de escribir nada cuenta como palabra
	# así eliminamos ese primer espacio
# warning-ignore:unused_variable
	for i in range (words.count("")):
		words.erase("")
	
	# comprobar si se ha introducido algún texto y no es sólo espacio en blanco
	if words.size() == 0:
		return
	
	var command_word = words.pop_front()
	
	for c in command_handler.valid_commands:
		if c[0] == command_word:
			# Comprubea si está habilitado
			if not command_handler.check_enable(command_word):
				output_text(str('Command "', command_word, '" does not exist.'))
				return
			# Si es una macro
			if c[1]:
				for m in c[2]:
					# Ejecuta todos los comando almacenados
					output_text(command_handler.callv(m[0], [m[1]]))
				return
			# Crear una macro
			if command_word == 'macro': 
				output_text(command_handler.macro(words))
				return
			
			if words.size() != c[2].size():
				output_text(str('Failure executing command "', command_word, '", expected ', c[2].size(), " parameters" ))
				return
			for i in range (words.size()):
				if not check_type(words[i], c[2][i]):
					output_text(str('Failure executing command "', command_word, '", parameter ', (i + 1),
						' ("', words[i], '") is of the wrong type"' ))
					return
			if words.empty():
				output_text(command_handler.callv(command_word, [null]))
			else:
				output_text(command_handler.callv(command_word, words))
			return
	output_text(str('Command "', command_word, '" does not exist.'))
	

func get_pos_macro(macro_name):
	var size = command_handler.valid_commands.size()
	for i in range (size):
		if command_handler.valid_commands[i][0] == macro_name:
			return i
	return size

# comrpueba si el tipo del texto es igual que el argumento
func check_type(string, type):
	if type == command_handler.ARG_INT:
		return string.is_valid_integer()
	if type == command_handler.ARG_FLOAT:
		return string.is_valid_float()
	if type == command_handler.ARG_STRING:
		return true
	if type == command_handler.ARG_BOOL:
		return (string == "true" or string == "false")
	return false

# Añade el nuevo texto a la consola, hace scroll para abajo auto.
func output_text(text):
	if output_box.text != "":
		output_box.text = str(output_box.text, "\n")
	output_box.text = str(output_box.text, text)
	output_box.scroll_vertical = INF

# Añade el nuevo texto a la consola, hace scroll para abajo auto.
func macro_output_text():
	var text = ''
	for m in command_handler.valid_commands:
		if m[1]:
			text = str(text, m[0], '\n')
	macro_output.text = text
	macro_output.scroll_vertical = INF

func _on_input_text_entered(new_text):
	input_box.clear()
	#input_box.release_focus()
	process_command(new_text)

