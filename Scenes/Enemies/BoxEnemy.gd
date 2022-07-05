extends RigidBody2D

signal enemy_died(points)
export var life = 30
export var points = 10
export var damage = 5

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func damage_life(damage):
	life -= damage
	if life <= 0:
		emit_signal("enemy_died", points)
		queue_free()

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func change_position_text(new_text) -> void:
	$PositionText.text = String(int(new_text))
