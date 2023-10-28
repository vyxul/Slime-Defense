extends PathFollow2D

@export var blueSlime: BlueSlime

@onready var moveSpeed = 0

# Called when the node enters the scene tree for the first time.
func _ready():
#	print_debug("blueSlime moveSpeed: %d" % moveSpeed)
	visible = false
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
#	progress += moveSpeed 
	pass


func _physics_process(delta):
	progress += moveSpeed * delta
	pass
	
func start():
#	print_debug("%s, currentSpeed: %d, newSpeed: %d" % [name, moveSpeed, blueSlime.moveSpeed])
	visible = true
	moveSpeed = blueSlime.moveSpeed
#	print_debug("newSpeed: %d" % moveSpeed)


func _on_blue_slime_exit_reached(damage):
	SignalGlobal.enemyReachedExit.emit(damage)
	queue_free()
	pass # Replace with function body.


func _on_blue_slime_health_depleted():
	SignalGlobal.enemyHealthDepleted.emit()
	queue_free()
	pass # Replace with function body.
