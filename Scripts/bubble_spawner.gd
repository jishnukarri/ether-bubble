extends Node3D

const BUBBLE = preload("res://Scenes/bubble.tscn")
const height = 15

var wave = 0
const MAX_WAVES = 100
# for each wave random bubbles between 3-5 bubbles spawn in


func spawn_bubble(radius, x, z) -> void:
	var bubble = BUBBLE.instantiate()
	
	add_child.call_deferred(bubble)
	await get_tree().process_frame
	
	bubble.global_position = Vector3(x, height, z)
	bubble.radius = radius

func wave_loop() -> void:
	while wave <= MAX_WAVES:
		print("starting loop for waves {wave}")
		var bubbles = randf_range(3,5)
		wave += 1
		Globals.tokens += wave * bubbles
		
		while Globals.tokens > 0 and Globals.tokens <= 10:
			var x = randi_range(-10, 10)
			var z = randi_range(-10, 10)
			var radius = randf_range(0.5, 5.0)
			
			if Globals.tokens > radius:
				print("bubble1")
				spawn_bubble(radius, x, z)
				print("bubble1")
				Globals.tokens -= radius
			else:
				radius = Globals.tokens
				print("bubble1")
				spawn_bubble(radius, x, z)
				print("bubble1")
				Globals.tokens = 0
		await get_tree().create_timer(25.0).timeout
func _ready() -> void:
	wave_loop()
