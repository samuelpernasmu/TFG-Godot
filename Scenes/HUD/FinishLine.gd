extends Node

signal enemy_collide(points)


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func hide_FL()-> void:
	$FinishLine.hide()

func show_FL()-> void:
	$FinishLine.show()

func _on_SZArea_body_entered(body):
	emit_signal("enemy_collide", body.damage)
	body.queue_free()
