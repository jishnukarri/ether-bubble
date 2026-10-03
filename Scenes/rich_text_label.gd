extends Label



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var fps = "fps : %s" %[Engine.get_frames_per_second()]
	var score = "score : %s %s" %[GLOBAL.score,GLOBAL.score_per_second]
	var bubbles = "bubbles : %s" %[GLOBAL.bubbles]
	text = fps + "\n" +score + "\n" + bubbles
