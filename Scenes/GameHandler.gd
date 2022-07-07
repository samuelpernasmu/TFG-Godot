extends Node

var level_file = 'res://last_level.txt'
var scores_file = 'res://scores.txt'
var commands_file = 'res://commands.txt'

enum {
	ARG_INT,
	ARG_STRING,
	ARG_FLOAT,
	ARG_BOOL
}

var basic_commands =[
	["macro",
		false,
		[]],
	["pause",
		false,
		[]],
	["move",
		false,
		[ARG_FLOAT]],
	["shot", 
		false, 
		[]],
	["delete",
		false,
		[ARG_STRING]],
	["ray_speed",
		false,
		[ARG_INT]],
	["ray_degree",
		false,
		[ARG_INT]],
	["speed",
		false,
		[ARG_INT]]
]

var scores = Array()

var level_data = {
	level = 0,
	score = 0,
	time = '00:00'
}

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in 8:
		scores.append_array([[i, 0, 0]])

func new_game() -> void:
	level_data.level = 0
	level_data.score = 0
	level_data.time = '00:00'
	write_level()

func next_level() -> void:
	level_data.level = level_data.level + 1
	level_data.score = 0
	level_data.time = '00:00'

func restart_level() -> void:
	level_data.score = 0
	level_data.time = '00:00'


func save_commands():
	var file = File.new()
	file.open(commands_file, File.WRITE)
	var save_nodes = get_tree().get_nodes_in_group("persist")
	
	for node in save_nodes:
		# Call the node's save function.
		var node_data = node.call("save_commands")
		# Store the save dictionary as a new line in the save file.
		file.store_line(to_json(node_data))
	file.close()

func load_commands():
	var commands
	var file = File.new()
	var err = file.file_exists(commands_file)
	if !err:
		var command_node = get_tree().get_nodes_in_group("persist")
		for i in command_node:
			i.load_commands(basic_commands)
		return
	
	file.open(commands_file, File.READ)
	
	var node_data = parse_json(file.get_line())
	# Now we set the remaining variables.
	for i in node_data.keys():
		commands = node_data[i]
	file.close()
	
	var command_node = get_tree().get_nodes_in_group("persist")
	for i in command_node:
		i.load_commands(commands)

func save_scores():
	var new_data = Array()
	
	for d in scores:
		if d[0] == level_data.level and level_data.score > int(d[1]):
			new_data.append_array([[level_data.level, level_data.score, level_data.time]])
			continue
		new_data.append_array([d])
	
	scores = new_data
	write_scores()

func write_scores():
	var file = File.new()
	var err = file.file_exists(scores_file)
	if !err:
		printerr('File does not exist')
	
	file.open(scores_file, File.WRITE)
	var store_data = level_data.duplicate()
	for d in scores:
		store_data.level = d[0]
		store_data.score = d[1]
		store_data.time = d[2]
		file.store_line(to_json(store_data))
	file.close()

func read_scores():
	var new_data = Array()
	var file = File.new()
	var err = file.file_exists(scores_file)
	if !err:
		return
	
	file.open(scores_file, File.READ)
	var j
	var line
	while not file.eof_reached():
		line = file.get_line()
		j = JSON.parse(line)
		if j.error == OK:
			new_data.append_array([[j.result.level, j.result.score, j.result.time]])
	file.close()
	scores = new_data

# almacena el siguiente nivel a jugar
func write_level():
	var file = File.new()
	var err = file.file_exists(level_file)
	if !err:
		printerr('File does not exist')
	
	file.open(level_file, File.WRITE)
	file.store_line(String(level_data.level))
	file.close()

# recupera el siguiente nivel a jugar
func read_level():
	var new_data = Array()
	var file = File.new()
	var err = file.file_exists(level_file)
	if !err:
		level_data.level = 0
	
	file.open(level_file, File.READ)
	level_data.level = int(file.get_line())
	file.close()
	
	if level_data.level == 9:
		level_data.level = -1
		next_level()
