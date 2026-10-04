extends Node3D

var bubbles: Array[Node3D] = []

func _ready() -> void:
	$Area.body_entered.connect(_on_area_body_entered)
	$Area.body_exited.connect(_on_area_body_exited)

func _on_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("Bubble"):
		bubbles.append(body)
		body.grow(1.5)

func _on_area_body_exited(body: Node3D) -> void:
	if body.is_in_group("Bubble"):
		bubbles.erase(body)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("attack"):
		for bubble in bubbles:
			if is_instance_valid(bubble):
				bubble.pop()
