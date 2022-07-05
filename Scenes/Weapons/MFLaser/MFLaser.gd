extends Node2D

var is_firing := false setget set_is_firing

# Called when the node enters the scene tree for the first time.
func _ready():
	set_physics_process(false)
	$MotionFunc.add_exception(owner)

func set_is_firing(firing: bool) -> void:
	is_firing = firing

	set_physics_process(is_firing)
	$MotionFunc.is_casting = is_firing

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
