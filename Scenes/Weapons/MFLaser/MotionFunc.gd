extends RayCast2D

#     /(float, 100) Limitar potencia máxima
var power = 50
# ángulo de lanzamiento
var degree = 45
# tiempo que permanece en el aire el rayo (afecta a la distancia)
var air_time = 30
# tiempo aparición rayo
var growth_time = 0.1
# gravedad
var gravity = -9.8
var speed_clamp = 100.0
# número de puntos de la línea
var line_points = 100

var is_colliding = false
var global_number_point = 0
var collision_point

var is_casting = false setget set_is_casting
var prueba = false

# Called when the node enters the scene tree for the first time.
# Por defecto desactiva las físicas del láser y apunta a la pos(0, 0)
func _ready() -> void:
	set_physics_process(false)
	$Pivot.rotation = ((degree - 90) * -1) * PI / 180
	prueba = true

func _physics_process(delta) -> void:
	clamp(power, 0.0, speed_clamp)
	#$CollisionParticle.emitting = is_colliding
	if !is_colliding:
		calculate_trajectory()
	else:
		$CollisionParticle.emitting = true
		$CollisionParticle.global_rotation = get_collision_normal().angle()
		# le indica la posición de la colisión
		$CollisionParticle.position = collision_point
		




func calculate_trajectory():
	var points = []
	var componentX = power * sin($Pivot.rotation)
	var componentY = power * cos($Pivot.rotation)
	
	for point in line_points:
		var time = air_time * point / line_points
		var dx = time * componentX
		var dy = -1.0 * (time * componentY + 0.5 * gravity * time * time)

		points.append(Vector2(dx, dy)) 
		cast_to = Vector2(dx, dy)
		force_raycast_update()
		if is_colliding():
			is_colliding = true
			collision_point = Vector2(dx, dy)
			break
		is_colliding = false
		
	
	#cast_to = Vector2(dx, dy)
	$Line2D.points = points
	

func set_is_casting(check: bool) -> void:
	is_casting = check
	$Pivot.rotation = ((degree - 90) * -1) * PI / 180
	$CastingParticle.global_rotation = (degree * -1) * PI / 180
	
	if is_casting:
		$CastingParticle.emitting = is_casting
		appear()
	else:
		$CastingParticle.emitting = is_casting
		$CollisionParticle.emitting = false
		is_colliding = false
		global_number_point = 0
		cast_to = Vector2.ZERO
		var cont = 0
		disappear()
		while cont <= global_number_point:
			$Line2D.points.remove(cont)
			cont += 1
	
	set_physics_process(is_casting)

func appear() -> void:
	if $Tween.is_active():
		$Tween.stop_all()
	$Tween.interpolate_property($Line2D, "width", 0, 10.0, growth_time)
	$Tween.start()

func disappear() -> void:
	$Tween.stop_all()
	$Tween.interpolate_property($Line2D, "width", 10.0, 0, growth_time)
	$Tween.start()

