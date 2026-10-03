extends RigidBody3D

const BUBBLE = preload("res://Scenes/bubble.tscn")
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

func pop() -> void:
	var points = GLOBAL.point_bonus + radius
	if GLOBAL.super_crit:
		if randf() < GLOBAL.super_crit:
			GLOBAL.score += int(points * GLOBAL.super_crit_multiplier)
	elif GLOBAL.crit:
		if randf() < GLOBAL.crit:
			GLOBAL.score += int(points * GLOBAL.crit_multiplier)
	else:
		GLOBAL.score += int(points)
	print(GLOBAL.score)
	queue_free()

func split() -> void:
	if randf() < GLOBAL.split_chance:
		var new_radius = radius / 2
		
		var bubble_1 = BUBBLE.instantiate()
		var bubble_2 = BUBBLE.instantiate()
		
		get_parent().add_child(bubble_1)
		get_parent().add_child(bubble_2)
		
		bubble_1.radius = new_radius
		bubble_2.radius = new_radius
		
		bubble_1.global_position = global_position + Vector3(new_radius, 0, 0)
		bubble_2.global_position = global_position - Vector3(new_radius, 0, 0)

func _on_body_entered(body: Node) -> void:
	if body == self:
		return
	elif body.is_in_group("Bubble"):
		if body not in stuck_bubbles:
			stuck_bubbles.append(body)
	else:
		stuck_bubbles.clear()
		queue_free()
		GLOBAL.tokens -= 1 
		
func _on_body_exited(body: Node) -> void:
	if body == self:
		return
	elif body in stuck_bubbles:
		stuck_bubbles.erase(body)
