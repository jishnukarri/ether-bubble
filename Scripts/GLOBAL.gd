extends Node

var tokens: = 0
var bubbles = 0 # amount of bubbles present in the game at any time
const MAX_BUBBLE = 50 # for each wave random bubbles between 3-5 bubbles spawn in
var wave = 0

var score: = 0
var crit: = 0.10
var super_crit: = 0.01
var crit_multiplier: = 2.0
var super_crit_multiplier: = 3.0
var split_chance: = 0.30
var point_bonus: = 1

signal weapon_changed

var current_weapon: = 1
var weapon_equipped: = 0

var old_score: int = 0
var score_per_second: float = 0.0
var timer: float = 0.0

func _process(delta: float) -> void:
	timer += delta
	
	if timer >= 2.0:
		score_per_second = (score - old_score)/2
		old_score = score
		timer = 0.0

func toggle() -> void:
	weapon_equipped = 1 - weapon_equipped

func _set_weapon(weapon: int) -> void:
	toggle()
	if weapon_equipped == 0:
		weapon_changed.emit(0)
	else:
		current_weapon = weapon
		weapon_changed.emit(current_weapon)
