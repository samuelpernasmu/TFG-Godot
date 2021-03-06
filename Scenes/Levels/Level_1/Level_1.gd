extends "res://Scenes/Levels/Level_base.gd"

export(PackedScene) var enemy_1

onready var command_handler = get_node("HUD/TopMenu/CommandConsole/CommandHandler")

var enemies = 10

func check_commands():
	pass
	

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	get_tree().call_group("enemies", "queue_free")
	check_commands()
	$HUD.write_level()
	#$HUD/TopMenu.change_speed_display()
	#$ShipDefense.change_movement()

func _on_BoxEnemiesSpawnTimer_timeout():
		# Elige una posición random del Path2D
	var enemies_spawn_location = get_node("ControlPath/EnemiesPath/EnemiesSpawnLocation");
	#enemies_spawn_location.offset = randi()
	enemies_spawn_location.global_position.y = rand_range($UpPosition.position.y, $DownPosition.position.y)
	# Crear una instancia de mob y añadirla a la escena
	var enemy = enemy_1.instance()
	add_child(enemy)
	
	enemy.connect("enemy_died", self, "_on_Enemy_die")
	
	# Dirección de Mob perpendicular a la dirección del Path2D
	var direction = enemies_spawn_location.rotation + PI + (PI / 2)
	
	# Seleccionar una posición random para hacer spawn
	enemy.position = enemies_spawn_location.global_position
	enemy.change_position_text((700-enemy.position.y)-40)
	# Dirección a la que apunta 
	enemy.rotation = direction
	
	# Elegir la velocidad
	var velocity = Vector2(rand_range(-40.0, -150.0), 0.0)
	enemy.linear_velocity = velocity
	
func finish_game() -> void:
	get_tree().call_group("enemies", "queue_free")
	$BoxEnemiesSpawnTimer.stop()
	$TotalTime.stop()

func _on_Enemy_die(points, pos) -> void:
	var aux_min = ""
	var aux_seg = ""
	GameHandler.level_data.score += points
	#$HUD.add_points(total_score)
	enemies = enemies - 1
	if enemies == 0:
		finish_game()
		if total_min < 10:
			aux_min = "0"
		if total_seg < 10:
			aux_seg = "0"
		$HUD.show_final_message(str("Total Score: ", String(GameHandler.level_data.score), " \nTotal Time: ", aux_min, String(total_min), ":", aux_seg, String(total_seg)))


func _on_enemy_damage(points):
	GameHandler.level_data.score -= points
	#$HUD.add_points(total_score)


func _on_TotalTime_timeout():
	var aux_min = ""
	var aux_seg = ""
	
	total_seg += 1
	if total_seg > 59:
		total_min += 1
		total_seg = 0
		
	if total_min < 10:
		aux_min = "0"
	if total_seg < 10:
		aux_seg = "0"
	
	GameHandler.level_data.time = str(aux_min, String(total_min), ":", aux_seg, String(total_seg))
	#$HUD.add_time(total_time)


func _on_HUD_endgame():
#	GameHandler.level_data.score = total_score
#	GameHandler.level_data.time = total_time
	emit_signal("endgame")


func _on_HUD_pause_game():
	get_tree().paused = !get_tree().paused


func _on_HUD_intro_finished():
	$TotalTime.start()
	$BoxEnemiesSpawnTimer.start()


func _on_HUD_return_main():
	get_tree().paused = !get_tree().paused
	emit_signal("return_main")

func _on_ShipDefense_dead():
	finish_game()
	$HUD.show_gameover_message('Game Over')


func _on_HUD_gameover():
	emit_signal("return_main")
