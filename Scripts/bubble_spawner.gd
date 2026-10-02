extends Node3D

const BUBBLE = preload("res://Scenes/bubble.tscn")
const height = 15

var wave = 0
var tokens = 0

func spawn_bubble(radius, x, z) -> void:
	var bubble = BUBBLE.instantiate()
	get_tree().current_scene.add_child.call_deferred(bubble)
	
	bubble.global_position = Vector3(x, height, z)
	bubble.radius = radius
	
func wave_loop() -> void:
	while true:
		wave += 1
		tokens += wave * 10
		
		while tokens > 0 and tokens <= 20:
			var x = randi_range(-10, 10)
			var z = randi_range(-10, 10)
			var radius = randf_range(0.5, 5.0)
			
			if tokens > radius:
				spawn_bubble(radius, x, z)
				tokens -= radius
			else:
				radius = tokens
				spawn_bubble(radius, x, z)
				tokens = 0
		await get_tree().create_timer(25.0).timeout
func _ready() -> void:
	wave_loop()
