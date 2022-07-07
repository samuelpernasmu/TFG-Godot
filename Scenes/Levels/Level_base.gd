extends Node


signal return_main
signal add_points(points)
signal endgame

var total_seg = 0
var total_min = 0
var count_enemies = 0
var spawn_hp
var hp = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
