extends RigidBody3D

const BUBBLE = preload("res://Scenes/bubble.tscn")
const bubbles_constant: = 0.05
const gravity: = 10
const stick_strength: = 100.0

@export var radius: float = 1.0

var downward_force : float
var volume : float
var stuck_bubbles: Array[RigidBody3D] = []

func _update_size() -> void:
	$Mesh.mesh.radius = radius
	$Mesh.mesh.height = radius * 2.0
	$Collision.shape.radius = radius

func stick_bubbles(body: RigidBody3D) -> void:
	var direction = body.global_position - global_position
	var distance = direction.length()
	var desired_distance = body.radius + radius
	var displacement = distance - desired_distance
	
	var force = direction.normalized() * displacement * stick_strength
	
	apply_central_force(-force)

func pop() -> void:
	var points = GLOBAL.point_bonus + radius
	if GLOBAL.super_crit:
		if randf() < GLOBAL.super_crit:
			points *= GLOBAL.super_crit_multiplier
	elif GLOBAL.crit:
		if randf() < GLOBAL.crit:
			points *= GLOBAL.crit_multiplier
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

func grow(size_mult: float) -> void:
	radius *= size_mult
	_update_size()

func spawn(bubble_radius: float, bubble_position: Vector3) -> void:
	var bubble = BUBBLE.instantiate()
	bubble.radius = bubble_radius
	bubble.position = bubble_position

func slime(size_mult: float) -> void:
	add_to_group("Slime")

func merge(body: Node) -> void:
	var merged_radius = radius + body.radius
	var merged_position = (position + body.position) / 2
	
	spawn(merged_radius, merged_position)
	
	body.queue_free()
	queue_free()

func _ready() -> void:
	contact_monitor = true
	max_contacts_reported = 8
	
	$Mesh.mesh = $Mesh.mesh.duplicate()
	$Collision.shape = $Collision.shape.duplicate()
	
	_update_size()
	
	downward_force = gravity / radius * bubbles_constant

func _physics_process(_delta: float) -> void: 
	downward_force = gravity / radius * bubbles_constant
	apply_central_force(Vector3.DOWN * downward_force)
	
	for body in stuck_bubbles:
		stick_bubbles(body)

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("Bubble"):
		if body not in stuck_bubbles:
			stuck_bubbles.append(body)
		if body.is_in_group("Slime"):
			merge(body)
	else:
		GLOBAL.bubbles -= 1
		queue_free()
		
func _on_body_exited(body: Node) -> void:
	if body in stuck_bubbles:
		stuck_bubbles.erase(body)
