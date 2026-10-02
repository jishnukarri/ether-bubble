extends Node3D

const WEAPONS = [
	preload("res://Scenes/bone_scythe.tscn")
]

var current_weapon_index: = 0
var current_weapon :  Node3D

func _equip(index: int) -> void:
	if current_weapon:
		current_weapon.queue_free()
	
	current_weapon = WEAPONS[index].instantiate()
	$Camera3D/WeaponHolder.add_child(current_weapon)
