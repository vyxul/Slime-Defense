extends Node2D

@onready var area2D = $Area2D
@onready var colorRect = $ColorRect
@onready var timer = $Timer

var inPlacementMode: bool = false
var placementOkay: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !inPlacementMode:
		return
	
	position = get_global_mouse_position()
	var collisions = area2D.get_overlapping_bodies().size()
	if collisions == 0:
		colorRect.color = Color(0, 1, 0, 0.196)
		placementOkay = true
	elif collisions > 0:
		colorRect.color = Color(1, 0, 0, 0.196)
		placementOkay = false
	else:
		print_debug("collisions (%d) is negative, shouldn't happen")

func setPlacementMode(state: bool):
	inPlacementMode = state
	visible = state

func getPlacementOkay() -> bool:
	return placementOkay
