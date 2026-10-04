extends CharacterBody3D

const JUMP_VELOCITY = 4.5

const WEAPONS = [
	preload("res://Scenes/weapons/bone_scythe.tscn"),
	preload("res://Scenes/weapons/bubble_secptre.tscn"),
	preload("res://Scenes/weapons/bubble_star.tscn")
]

@onready var camera = $Camera_Holder/Camera
@onready var camera_holder = $Camera_Holder

var mouse_sensitivity = 0.01
var current_weapon_index: = 0
var current_weapon :  Node3D

func _ready() -> void:
	GLOBAL.weapon_changed.connect(_on_weapon_changed)

func _equip(index: int) -> void:
	if current_weapon:
		current_weapon.queue_free()
	
	current_weapon = WEAPONS[index - 1].instantiate()
	$Weapon_Holder.add_child(current_weapon)
	$Weapon_Holder.get_child(0).position = Vector3(1.5, 0, -2)

func _on_weapon_changed(weapon: int) -> void:
	if current_weapon:
		current_weapon.queue_free()
	if weapon >= 1:
		_equip(weapon)

func _input(event):
	if event is InputEventMouseMotion:
		var mouse_movement = event.relative
		if Input.is_action_pressed("drag"):
			rotate_y(-event.relative.x * mouse_sensitivity)
			camera_holder.rotation.x = clamp(camera_holder.rotation.x - mouse_movement.y * mouse_sensitivity, deg_to_rad(-80), deg_to_rad(80))
	if Input.is_action_just_pressed("zoom_out"):
		camera.position.z = clamp(camera.position.z + 0.75, 0, 4)
		camera.position.y = clamp(camera.position.y + 1, 0, 3)
	elif Input.is_action_just_pressed("zoom_in"):
		camera.position.z = clamp(camera.position.z - 0.75, 0, 4)
		camera.position.y = clamp(camera.position.y - 1, 0, 3)
	if Input.is_action_just_pressed("equip"):
		print("weapon")
		GLOBAL._set_weapon(GLOBAL.current_weapon)

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if position.y < -50:
		position.y = 15
		position.x = 0
	
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("left", "right", "forward", "backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * GLOBAL.player_speed
		velocity.z = direction.z * GLOBAL.player_speed
	else:
		velocity.x = move_toward(velocity.x, 0, GLOBAL.player_speed)
		velocity.z = move_toward(velocity.z, 0, GLOBAL.player_speed)

	move_and_slide()
