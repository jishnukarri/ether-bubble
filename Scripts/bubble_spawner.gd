extends Node3D

const BUBBLE = preload("res://Scenes/bubble.tscn")

var game_init: bool = false

func _finish_spawn(bubble, x, z) -> void:
	var height = randi_range(15, 25)
	bubble.global_position = Vector3(x, height, z)

func spawn_bubble(radius, x, z) -> void:
	var bubble = BUBBLE.instantiate()
	bubble.radius = radius
	
	add_child.call_deferred(bubble)
	call_deferred("_finish_spawn", bubble, x, z)
	
"""
			var x = randi_range(-10, 10)
			var z = randi_range(-10, 10)
			var radius = randf_range(0.5, 5.0)
"""
func wave_loop() -> void:
	while GLOBAL.wave >= 0:
		print("wave started")
		GLOBAL.wave += 1
		if GLOBAL.bubbles <= GLOBAL.MAX_BUBBLE:
			print("buuble start")
			var bubble_amount = randf_range(5,35)
			if game_init:
				bubble_amount = randf_range(5,35)
			else:
				bubble_amount = randf_range(45,50)
				game_init = true
			for bubble in range(bubble_amount):
				var x = randi_range(-50, 50)
				var z = randi_range(-50, 50)
				var radius = randf_range(0.5, 5.0)
				print("b spawn start")
				if GLOBAL.bubbles > GLOBAL.MAX_BUBBLE:
					break
				spawn_bubble(radius,x,z)
				GLOBAL.bubbles += 1
			await get_tree().create_timer(10.0).timeout
func _ready() -> void:
	wave_loop()
