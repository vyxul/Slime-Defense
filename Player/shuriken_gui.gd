extends Panel


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# 0 for show shuriken, 1 for show sphere (no shuriken)
func update(num: int):
	$Sprite2D.frame = num
