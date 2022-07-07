extends KinematicBody2D

signal dead
signal emit_position(new_pos)
signal emit_life(new_life)
signal enemy_collide(points)

export var Laser_enable = true 
export var MFLaser_enable = false
export var speed = 60
export var life = 100
# Indica se la nave se puede mover mediante las felchas o no
# Si está a false se mueve mediante desplazamientos
export var allow_movement = false

var velocity
var positionY
var target

# Called when the node enters the scene tree for the first time.
func _ready():
	target = position.y

# Cambia la manera en la que se mueve la nave
# True: Se puede mover con las flechas
# False: Se mueve sólo indicando el desplzamiento (por defecto)
func change_movement() -> void:
	allow_movement = !allow_movement

# ahora mismo sólo cambia entre dos armas
func change_weapon() -> void:
	Laser_enable = !Laser_enable
	MFLaser_enable = !MFLaser_enable

# Dispara el arma activada
func shot_laser(shooting) -> void:
	#$AllWeapons.shot_weapon(event)
	if Laser_enable:
		$Laser.is_firing = shooting
	elif MFLaser_enable:
		$MFLaser.is_firing = shooting

# Calcula vector de velocidad en base a un desplazamiento dado 
# multiplicando por la velocidad de la nave por defecto
func update_position(new_pos) -> void:
	positionY = Vector2(0, (new_pos * -1))
	#positionY = position.y + (new_pos * -2)
	velocity = positionY.normalized() * speed
	target = positionY.y + position.y

# Mueve la nave con las flechas (up and down)
func get_input() -> void:
	# Detect up/down/left/right keystate and only move when pressed.
	velocity = Vector2()
	if Input.is_action_pressed('ui_down'):
		velocity.y += 1
	if Input.is_action_pressed('ui_up'):
		velocity.y -= 1
	velocity = velocity.normalized() * speed

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	emit_signal("emit_position", (700-position.y)-40)
	emit_signal("emit_life", life)
	if !allow_movement:
		var distance = position.y - target
		if distance > 1 or distance < -1:
			var collision = move_and_collide(velocity * delta)
			if collision: 
				target = position.y
	else:
		get_input()
		var collision = move_and_collide(velocity * delta)
		if collision: 
			target = position.y


func _on_Area2D_area_entered(area):
	life = life - area.damage
	emit_signal("enemy_collide", area.damage)
	area.queue_free()
	if life <= 0:
		emit_signal("dead")


func _on_Area2D_body_entered(body):
	if body.is_in_group("powerups"):
		if life == 100:
			GameHandler.level_data.score += body.get_energy()
		else: 
			life += body.get_energy()
		body.queue_free()
		return
	life = life - body.damage
	emit_signal("enemy_collide", body.damage)
	body.queue_free()
	if life <= 0:
		emit_signal("dead")
