extends PathFollow2D

signal healthDepleted
signal exitReached(damage)

@export var blueSlime: BlueSlime

@onready var moveSpeed = blueSlime.moveSpeed

# Called when the node enters the scene tree for the first time.
func _ready():
	print_debug("blueSlime moveSpeed: %d" % moveSpeed)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
#	progress += moveSpeed 
	pass


func _physics_process(delta):
	progress += moveSpeed * delta
	pass


func _on_blue_slime_exit_reached(damage):
	exitReached.emit(damage)
	pass # Replace with function body.


func _on_blue_slime_health_depleted():
	healthDepleted.emit()
	pass # Replace with function body.
