extends Node


const x_min = -600
const x_max = 600
const y_min = -600
const y_max = 600

var player_speed = 5.0
const BASE_SPEED := 5.0
const SPEED_PER_POINT := 0.05   # each point adds 5% speed
const MAX_SPEED := 30.0     # never faster than 2.5x

const MIN_CLOUDS = 450
const MAX_CLOUDS = 500
var clouds = 0

var tokens: = 0
var bubbles = 0 # amount of bubbles present in the game at any time
const MIN_BUBBLE = 100
const MAX_BUBBLE = 600 # for each wave random bubbles between 3-5 bubbles spawn in
var wave = 0


var score: = 0
var crit: = 0.10
var super_crit: = 0.01
var crit_multiplier: = 2.0
var super_crit_multiplier: = 3.0
var split_chance: = 0.30
var point_bonus: = 1

signal weapon_changed

var current_weapon: = 2
var weapon_equipped: = 0

var old_score: int = 0
var score_per_second: float = 0.0
var timer: float = 0.0


func get_speed_multiplier() -> float:
	return 1.0 + score * SPEED_PER_POINT

func _process(delta: float) -> void:
	timer += delta
	
	
	
	if timer >= 2.0:
		score_per_second = (score - old_score)/2
		old_score = score
		timer = 0.0
	player_speed = BASE_SPEED + get_speed_multiplier()
		

func toggle() -> void:
	weapon_equipped = 1 - weapon_equipped

func _set_weapon(weapon: int) -> void:
	toggle()
	if weapon_equipped == 0:
		weapon_changed.emit(0)
	else:
		current_weapon = weapon
		weapon_changed.emit(current_weapon)
