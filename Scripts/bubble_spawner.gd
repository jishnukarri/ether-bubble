extends Node3D

const MAX_WAVES = 100
# for each wave random bubbles between 3-5 bubbles spawn in
const BUBBLE = preload("res://Scenes/bubble.tscn")
const height = 15

var wave = 0


func _finish_spawn(bubble, x, z) -> void:
	bubble.global_position = Vector3(x, height, z)

func spawn_bubble(radius, x, z) -> void:
	var bubble = BUBBLE.instantiate()
	bubble.radius = radius
	
	add_child.call_deferred(bubble)
	call_deferred("_finish_spawn", bubble, x, z)
	

func wave_loop() -> void:
	while wave <= MAX_WAVES:
		print("starting loop for waves %s" %[wave])
		var bubbles = randf_range(3,5)
		wave += 1
		GLOBAL.tokens += wave * bubbles
		
		while GLOBAL.tokens > 0 and GLOBAL.tokens <= 10:
			var x = randi_range(-10, 10)
			var z = randi_range(-10, 10)
			var radius = randf_range(0.5, 5.0)
			
			if GLOBAL.tokens > radius:
				print("bubble1")
				spawn_bubble(radius, x, z)
				print("bubble1")
				GLOBAL.tokens -= radius
			else:
				radius = GLOBAL.tokens
				print("bubble1")
				spawn_bubble(radius, x, z)
				print("bubble1")
				GLOBAL.tokens = 0
		await get_tree().create_timer(25.0).timeout
func _ready() -> void:
	wave_loop()
