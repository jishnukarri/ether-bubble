extends DirectionalLight3D


const SUN_SPEED := 6.0

const START_ANGLE := 0.0

# tilts the sun's path so it doesn't go straight overhead
const SUN_TILT := -30.0

const MAX_ENERGY := 1.2
const SUNRISE_COLOR := Color(1.0, 0.55, 0.3)
const MIDDAY_COLOR := Color(1.0, 0.97, 0.9)

var sun_angle := START_ANGLE


func _ready() -> void:
	rotation_degrees.y = SUN_TILT
	_update_sun()


func _process(delta: float) -> void:
	sun_angle = fmod(sun_angle + SUN_SPEED * delta, 360.0)
	_update_sun()


func _update_sun() -> void:
	rotation_degrees.x = -sun_angle

	var height := sin(deg_to_rad(sun_angle))

	light_energy = clamp(height * 3.0, 0.0, 1.0) * MAX_ENERGY

	# orange when low, white when high
	light_color = SUNRISE_COLOR.lerp(MIDDAY_COLOR, clamp(height * 2.0, 0.0, 1.0))
