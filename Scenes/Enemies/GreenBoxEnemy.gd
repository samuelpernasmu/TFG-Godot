extends RigidBody2D


export(PackedScene) var lightbullet
signal enemy_died(points, pos)
export var life = 35
export var points = 12
export var damage = 5

var stop_time

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	stop_time = rand_range(6, 10)
	pass # Replace with function body.


func damage_life(dam):
	life -= dam
	if life <= 0:
		emit_signal("enemy_died", points, global_position)
		queue_free()

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func change_position_text(new_text) -> void:
	$PositionText.text = String(int(new_text))


func _on_Stop_timeout():
	stop_time = stop_time - 1
	if stop_time <= 0:
		linear_velocity = Vector2(0.0, 0.0)
		$Shot.start()
		$Stop.stop()


func _on_Shot_timeout():
	var bullet = lightbullet.instance()
	add_child(bullet)
	bullet.rotation = rotation
	bullet.linear_velocity = Vector2(rand_range(-80.0, -150.0), 0.0)
	$Shot.start()
