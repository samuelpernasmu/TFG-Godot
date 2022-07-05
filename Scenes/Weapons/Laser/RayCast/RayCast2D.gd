extends RayCast2D

export var cast_speed := 7000.0
export var max_length := 2000
export var growth_time := 0.1
export var damage := 10

# por defecto desactiva las físicas del nodo
var is_casting := false setget set_is_casting
var allow_casting = true
var collision_object

# Called when the node enters the scene tree for the first time.
# Por defecto desactiva las físicas del láser y apunta a la pos(0, 0)
func _ready() -> void:
	set_physics_process(false)
	$Line2D.points[1] = Vector2.ZERO


func _physics_process(delta) -> void:
	cast_to = (cast_to + Vector2.RIGHT * cast_speed * delta).clamped(max_length)
	ray_particles()

func ray_particles():
	var cast_point := cast_to
	# actualiza la información sin esperar al procesamiento de frames
	force_raycast_update()
	$CollisionParticle.emitting = is_colliding()
	# si la línea ha colisionado, guarda el punto 
	if is_colliding():
		cast_point = to_local(get_collision_point())
		# devuelve la Normal del punto de colisión, de este modo 
		# las partículas de la explosión son perpendiculares a la zona
		$CollisionParticle.global_rotation = get_collision_normal().angle()
		# le indica la posición de la colisión
		$CollisionParticle.position = cast_point
		# Obtenemos objeto de colision
		collision_object = get_collider()
		if collision_object != null:
			if $DamageTime.is_stopped():
				collision_object.damage_life(damage)
				$DamageTime.start()
	# actualiza el punto destino del rayo, si ha colisionado el rayo termina en
	# el punto de colisión, sino en el punto por defecto
	$Line2D.points[1] = cast_point
	$BeamParticles.position = cast_point * 0.5
	$BeamParticles.process_material.emission_box_extents.x = cast_point.length() * 0.5


func set_is_casting(cast: bool) -> void:
	is_casting = cast
	
	if is_casting:
		cast_to = Vector2.ZERO
		$Line2D.points[1] = cast_to
		$BeamParticles.emitting = is_casting
		$CastingParticle.emitting = is_casting
		appear()
	else:
		$BeamParticles.emitting = is_casting
		$CastingParticle.emitting = is_casting
		$CollisionParticle.emitting = false
		disappear()
	# Activa o desactiva las físicas del nodo, por defecto están desactivadas
	set_physics_process(is_casting)

# el tiempo de aparecer/desaparecer tiene que ser el mismo o se queda mal
func appear() -> void:
	if $Tween.is_active():
		$Tween.stop_all()
	$Tween.interpolate_property($Line2D, "width", 0, 10.0, growth_time)
	$Tween.start()

func disappear() -> void:
	$Tween.stop_all()
	$Tween.interpolate_property($Line2D, "width", 10.0, 0, growth_time)
	$Tween.start()


# Cuando se acabe el tiempo de recarga puede disparar
func _on_RechargeTime_timeout():
	self.allow_casting = true


func _on_DamageTime_timeout():
	$DamageTime.stop()
