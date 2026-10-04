extends Node3D

const BUBBLE = preload("res://Scenes/bubble.tscn")


func _finish_spawn(bubble, x, z) -> void:
	var height = randi_range(15, 25)
	bubble.global_position = Vector3(x, height, z)

func spawn_bubble(radius, x, z) -> void:
	var bubble = BUBBLE.instantiate()
	bubble.radius = radius
	
	add_child.call_deferred(bubble)
	call_deferred("_finish_spawn", bubble, x, z)
	

func inital_wave_loop() -> void:
	for i in range(randf_range(GLOBAL.MIN_CLOUDS,GLOBAL.MAX_CLOUDS)):
		var x = randi_range(GLOBAL.x_min, GLOBAL.x_max)
		var z = randi_range(GLOBAL.y_min, GLOBAL.y_max)
		var radius = randf_range(0.5, 5.0)		
		spawn_bubble(radius,x,z)
		GLOBAL.bubbles += 1
		
func wave_loop() -> void:
	while GLOBAL.wave >= 0:
		GLOBAL.wave += 1
		if GLOBAL.bubbles <= GLOBAL.MAX_BUBBLE:
			var bubble_amount = randf_range(GLOBAL.MIN_BUBBLE,GLOBAL.MAX_BUBBLE)
			for bubble in range(bubble_amount):
				var x = randi_range(-50, 50)
				var z = randi_range(-50, 50)
				var radius = randf_range(0.5, 5.0)
				if GLOBAL.bubbles > GLOBAL.MAX_BUBBLE:
					break
				spawn_bubble(radius,x,z)
				GLOBAL.bubbles += 1
		await get_tree().create_timer(10.0).timeout
func _ready() -> void:
	inital_wave_loop()
	
func _process(delta: float) -> void:
	wave_loop()
