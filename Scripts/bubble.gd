extends RigidBody3D

const bubbles_constant: = 0.05
const gravity: = 9.8
const stick_strength: = 100.0

@export var radius: float = 1.0

var downward_force : float
var volume : float
var stuck_bubbles: Array[RigidBody3D] = []

func _update_size() -> void:
	$Mesh.mesh.radius = radius
	$Mesh.mesh.height = radius * 2.0
	$Collision.shape.radius = radius

func _ready() -> void:
	contact_monitor = true
	max_contacts_reported = 8
	
	$Mesh.mesh = $Mesh.mesh.duplicate()
	$Collision.shape = $Collision.shape.duplicate()
	
	_update_size()
	
	downward_force = gravity / radius * bubbles_constant

func stick_bubbles(body: RigidBody3D) -> void:
	var direction = body.global_position - global_position
	var distance = direction.length()
	var desired_distance = body.radius + radius
	var displacement = distance - desired_distance
	
	var force = direction.normalized() * displacement * stick_strength
	
	apply_central_force(-force)

func _physics_process(_delta: float) -> void: 
	downward_force = gravity / radius * bubbles_constant
	apply_central_force(Vector3.DOWN * downward_force)
	
	for body in stuck_bubbles:
		stick_bubbles(body)

func _on_body_entered(body: Node) -> void:
	if body == self:
		return
	elif body.is_in_group("Bubble"):
		if body not in stuck_bubbles:
			stuck_bubbles.append(body)
	else:
		stuck_bubbles.clear()
		queue_free()

func _on_body_exited(body: Node) -> void:
	if body == self:
		return
	elif body in stuck_bubbles:
		stuck_bubbles.erase(body)
