extends Node

export (PackedScene) var level_0
export (PackedScene) var level_1
export (PackedScene) var level_2
export (PackedScene) var level_3
export (PackedScene) var level_4
export (PackedScene) var level_5

export(PackedScene) var enemy_scene

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
	
	if GameHandler.level_data.level == 0:
		level = level_0.instance()
	if GameHandler.level_data.level == 1:
		level = level_1.instance()
	if GameHandler.level_data.level == 2:
		level = level_2.instance()
	if GameHandler.level_data.level == 3:
		level = level_3.instance()
	if GameHandler.level_data.level == 4:
		level = level_4.instance()
	if GameHandler.level_data.level == 5:
		level = level_5.instance()
	
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
	if GameHandler.level_data.level == 6:
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


func _on_SpawnTime_timeout():
		# Elige una posición random del Path2D
	var enemy_spawn_location = get_node("SpawnPath/PathFollow2D");
	enemy_spawn_location.offset = randi()
	
	# Crear una instancia de mob y añadirla a la escena
	var enemy = enemy_scene.instance()
	enemy.change_position_text("")
	add_child(enemy)
	
	# Dirección de Mob perpendicular a la dirección del Path2D
	var direction = enemy_spawn_location.rotation + PI / 2
	
	# Seleccionar una posición random para hacer spawn
	enemy.position = enemy_spawn_location.position
	
	# Dirección a la que apunta random
	direction += rand_range(-PI / 4, PI / 4)
	enemy.rotation = direction
	
	# Elegir la velocidad
	var velocity = Vector2(rand_range(150.0, 250.0), 0.0)
	enemy.linear_velocity = velocity.rotated(direction)
