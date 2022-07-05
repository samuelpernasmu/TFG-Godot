extends Node

signal dead
signal inform_life(new_life)
signal inform_position(new_position)
signal change_weapon
signal inform_damage(points)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _unhandled_input(event: InputEvent) -> void:
	
	if event.is_echo():
		return
	if event.is_action_pressed("change_weapon"):
		emit_signal("change_weapon")
		$Ship.change_weapon()
	if event.is_action_released("change_weapon"):
		pass

func show_defense() -> void:
	$Ship.show()

func hide_defense() -> void:
	$Ship.hide()

# Cambia la manera en la que se mueve la nave
# True: Se puede mover con las flechas
# False: Se mueve sólo indicando el desplzamiento (por defecto)
func change_movement() -> void:
	$Ship.change_movement()

func set_ship_speed(new_speed) -> void:
	$Ship.speed = new_speed

func _on_HUD_shot_weapon():
	$Ship.shot_laser(true)
	$ShotTime.start()

func _on_HUD_move_ship(new_pos):
	$Ship.update_position(new_pos)

func _on_HUD_change_weapon():
	$Ship.change_weapon()

func _on_HUD_change_power(new_power):
	$Ship/MFLaser/MotionFunc.power = new_power

func _on_HUD_change_degree(new_degree):
	$Ship/MFLaser/MotionFunc.degree = new_degree 


func _on_Ship_emit_position(new_pos):
	emit_signal("inform_position", new_pos)


func _on_HUD_speed_changed(new_speed):
	set_ship_speed(new_speed)


func _on_ShotTime_timeout():
	$Ship.shot_laser(false)


func _on_Ship_dead():
	emit_signal("dead")


func _on_Ship_emit_life(new_life):
	emit_signal("inform_life", new_life)


func _on_Ship_enemy_collide(points):
	emit_signal("inform_damage", points)
