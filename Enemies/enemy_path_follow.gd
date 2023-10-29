extends PathFollow2D
class_name EnemyPathFollow

# Need to get the Resource and Packed Scene of the enemy using the path
# Will need to later check if enemyScene has a specific method to ensure its an enemyScene
var enemySceneString: String
var enemyScene: PackedScene
var isCorrectlySetup: bool = true

var enemyChildNode = null

# Variable to decide how fast the enemy moves along the path, uses the enemy's move speed
var moveSpeed: int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false
#	linkEnemy("res://Enemies/blue_slime_enemy.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	progress += moveSpeed * delta
	
	if isCorrectlySetup && enemyChildNode:
		enemyChildNode.setPathProgress(progress_ratio)

func linkEnemy(enemySceneLocation: String):
	# Make sure that the location string leads to a valid file
	if (!FileAccess.file_exists(enemySceneLocation)):
		print_debug("%s is not a valid scene location." % enemySceneLocation)
		isCorrectlySetup = false
		return
		
	enemySceneString = enemySceneLocation
	enemyScene = load(enemySceneString)
	
	# Using setPathProgress() to see if its an enemy scene, 
	# could probably use a better way to ensure it's an enemy scene
	# Can't get this to work right now
#	if (!enemyScene.has_method("setPathProgress")):
#		print_debug("%s is not a valid enemy scene." % enemySceneLocation)
#		isCorrectlySetup = false
#		return
		
	var enemy = enemyScene.instantiate()
	enemy.exitReached.connect(_on_enemy_exit_reached.bind())
	enemy.healthDepleted.connect(_on_enemy_health_depleted)
	add_child(enemy)
	enemyChildNode = enemy

func start():
	if !isCorrectlySetup:
		print_debug("%s follower is not correctly set up with %s" %
					[name, enemySceneString])
		return
		
#	print_debug("%s, currentSpeed: %d, newSpeed: %d" % [name, moveSpeed, blueSlime.moveSpeed])
	visible = true
	moveSpeed = enemyChildNode.moveSpeed

func _on_enemy_exit_reached(damage):
	print_debug("testing")
	SignalGlobal.enemyReachedExit.emit(damage)
	queue_free()

func _on_enemy_health_depleted():
	print_debug("testing")
	SignalGlobal.enemyHealthDepleted.emit()
	queue_free()
