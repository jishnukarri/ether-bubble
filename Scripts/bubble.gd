extends RigidBody3D

const bubbles_constant: = 0.05
const air_flow_rate: = 0.1
const air_differential: = 0.25
const gravity: = 9.8
const stick_strength: = 10.0

@export var radius: = 1.0

var downward_force : float
var volume : float
var stuck_bubbles: Array[RigidBody3D] = []

func _update_size() -> void:
	print(radius)
	$Mesh.mesh.radius = radius
	$Mesh.mesh.height = radius * 2.0
	$Collision.shape.radius = radius
	$Area/Area_Collision.shape.radius = radius

func set_radius(new_radius: float) -> void:
	radius = new_radius
	volume = (4.0 / 3.0) * PI * pow(radius, 3)
	_update_size()

func _ready() -> void:
	$Mesh.mesh = $Mesh.mesh.duplicate()
	$Collision.shape = $Collision.shape.duplicate()
	$Area/Area_Collision.shape = $Area/Area_Collision.shape.duplicate()
	
	_update_size()
	
	volume = (4.0 / 3.0) * PI * pow(radius, 3)
	downward_force = gravity / volume * bubbles_constant

func stick_bubbles(body: RigidBody3D) -> void:
	var direction = body.global_position - global_position
	var distance = direction.length()
	var desired_distance = body.radius + radius
	var displacement = distance - desired_distance
	
	var force = direction.normalized() * displacement * stick_strength
	
	apply_central_force(-force)
	body.apply_central_force(force)

func air_conversion(body: RigidBody3D) -> void:
	var difference = volume - body.volume
	
	if difference > air_differential and body.volume > 0.5:
		var transfer = min(air_flow_rate, body.volume)
		volume += transfer
		body.volume -= transfer


func _physics_process(delta: float) -> void:
	downward_force = gravity / volume * bubbles_constant
	apply_central_force(Vector3.DOWN * downward_force)
	
	for body in stuck_bubbles:
		air_conversion(body)
		
		radius = pow((volume * 3.0) / (4.0 * PI), 1.0 / 3.0)
		
		stick_bubbles(body)
		
		_update_size()
		
		

func _on_area_body_entered(body: Node3D) -> void:
	if body == self:
		return
	elif body.is_in_group("Bubble"):
		if body not in stuck_bubbles:
			stuck_bubbles.append(body)
	else:
		stuck_bubbles.clear()
		queue_free()

func _on_area_body_exited(body: RigidBody3D) -> void:
	if body == self:
		return
	elif body in stuck_bubbles:
		stuck_bubbles.erase(body)
