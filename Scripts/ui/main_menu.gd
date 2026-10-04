extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$title.add_theme_font_override("font", load("res://Textures/UI/fonts/BUBBLEGUMS.TTF"))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_start_button_pressed() -> void:
	GLOBAL.bubbles = 0
	GLOBAL.clouds = 0
	get_tree().change_scene_to_file("res://Scenes/main.tscn")
