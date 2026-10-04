extends Node3D

func _ready() -> void:
	$Area.body_entered.connect(_on_area_body_entered)

func _on_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("Bubble"):
		body.split()
		body.pop()
