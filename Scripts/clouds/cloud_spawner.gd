extends Node3D

const clouds = [
	preload("res://Scenes/clouds/cloud_model_1.tscn"),
	preload("res://Scenes/clouds/cloud_model_2.tscn"),
	preload("res://Scenes/clouds/cloud_model_3.tscn")
]


func spawnCloud(cloud) -> void:
	var c_cloud = cloud.instantiate()

	# position
	var x = randf_range(-50, 50)
	var y = randf_range(20, 25)
	var z = randf_range(-50, 50)
	c_cloud.position = Vector3(x, y, z)

	# scale: wide and flat, so y gets a smaller range
	var sx = randf_range(0.6, 2.0)
	var sy = randf_range(0.6, 1.2)
	var sz = randf_range(0.6, 2.0)
	c_cloud.scale = Vector3(sx, sy, sz)

	# random spin so copies of the same model look different
	c_cloud.rotate_y(randf_range(0, TAU))

	add_child(c_cloud)
	GLOBAL.clouds += 1
	
	
func initalCloudSpawn() -> void:
	for i in range(randf_range(GLOBAL.MIN_CLOUDS,GLOBAL.MAX_CLOUDS)):
		var cloud = clouds.pick_random()
		if GLOBAL.clouds > GLOBAL.MAX_CLOUDS:
			break
		spawnCloud(cloud)

func spawnClouds() -> void:
	pass

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	initalCloudSpawn()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
