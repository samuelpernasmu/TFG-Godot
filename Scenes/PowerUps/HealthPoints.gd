extends RigidBody2D


export var energy = 5


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func get_energy():
	return energy

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
