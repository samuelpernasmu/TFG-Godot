extends RigidBody2D

signal enemy_died(points)
export var life = 10
export var damage = 8
export var points = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func damage_life(damage):
	life -= damage
	if life <= 0:
		emit_signal("enemy_died", points)
		queue_free()

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
