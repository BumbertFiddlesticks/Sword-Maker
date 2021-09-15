extends ColorRect


var time = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# might still jitter a little bit
func _process(delta):
	time += 0.02 #delta * 1.5
	rect_position.x = 342 - 0.5 * rect_min_size.x
	rect_position.y = 300 - 0.5 * rect_min_size.y + round(sin(time) * 20.0)
	#260.0 + round(sin(time) * 20.0)
