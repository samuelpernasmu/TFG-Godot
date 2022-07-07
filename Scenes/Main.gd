extends Node

export (PackedScene) var level_0
export (PackedScene) var level_1
export (PackedScene) var level_2
export (PackedScene) var level_3
export (PackedScene) var level_4
export (PackedScene) var level_5
export (PackedScene) var level_6
export (PackedScene) var level_7
export (PackedScene) var level_8

# Called when the node enters the scene tree for the first time.
func _ready():
	# Obtiene puntuaciones almacenadas
	GameHandler.read_scores()
	# Recupera nivel que tiene que jugar
	GameHandler.read_level()
	if GameHandler.level_data.level >= 1:
		$StartGame/StartMenu/Continue.disabled = false
	else:
		$StartGame/StartMenu/Continue.disabled = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func load_level() -> void:
	var level
	match(GameHandler.level_data.level):
		0:
			level = level_0.instance()
		1:
			level = level_1.instance()
		2:
			level = level_2.instance()
		3:
			level = level_3.instance()
		4:
			level = level_4.instance()
		5:
			level = level_5.instance()
		6:
			level = level_6.instance()
		7:
			level = level_7.instance()
		8:
			level = level_8.instance()
		_:
			return

	
	add_child(level)
	GameHandler.load_commands()
	level.connect("endgame", self, "_on_Level_finished")
	level.connect("return_main", self, "_on_Level_return_main")

func update_game_status():
	GameHandler.save_scores()
	GameHandler.save_commands()
	GameHandler.next_level()
	GameHandler.write_level()
	if GameHandler.level_data.level >= 1:
		$StartGame/StartMenu/Continue.disabled = false
	else:
		$StartGame/StartMenu/Continue.disabled = true

func _on_Level_finished():
	update_game_status()
	get_tree().get_nodes_in_group("levels")[0].queue_free()
	# Al terminar el último nivel carga menú inicio
	if GameHandler.level_data.level == 9:
		$StartGame/StartMenu/Continue.disabled = true
		$StartGame.show_start_menu()
		GameHandler.new_game()
		GameHandler.save_commands()
		GameHandler.write_level()
	else:
		load_level()
	#$StartGame.show_start_menu()

func _on_Level_return_main():
	GameHandler.restart_level()
	GameHandler.save_scores()
	GameHandler.save_commands()
	GameHandler.write_level()
	get_tree().get_nodes_in_group("levels")[0].queue_free()
	# Activa la opción de continuar
	if GameHandler.level_data.level >= 1:
		$StartGame/StartMenu/Continue.disabled = false
	else:
		$StartGame/StartMenu/Continue.disabled = true
	$StartGame.show_start_menu()

func _on_start_game():
	load_level()


