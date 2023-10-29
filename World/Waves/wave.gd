extends Node2D
class_name Wave

signal waveOver

@export var enemySpawnList:  Array[String] = []
@export var enemySpawnCount: Array[int]    = []
@export var enemySpawnInterval: float = 1

# Variables to make sure wave is set up correctly
var isCorrectlySetup: bool = true
var timer: Timer

# Variables to handle with managing wave enemies
var enemySpawnCountTotal: int = 0
var enemiesAlive: int = 0
var enemyTypeSpawnCounter: int = 0
var enemySpawnCounter: int = 0

# Variable to spawn enemies
var enemyPath: Path2D
var enemyPathResource = preload("res://Enemies/enemy_path_follow.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	timer = $Timer
	
	if !timer:
		print_debug("%s timer not correctly set up" % name)
		isCorrectlySetup = false
		
	if !enemySpawnList:
		print_debug("%s enemySpawnList is empty" % name)
		isCorrectlySetup = false
		
	if !enemySpawnCount:
		print_debug("%s enemySpawnCount is empty" % name)
		isCorrectlySetup = false
		
	if (enemySpawnList.size() != enemySpawnCount.size()):
		print_debug("enemySpawnList (%d) and enemySpawnCount (%d) lengths don't match" % 
					[enemySpawnList.size(), enemySpawnCount.size()])
		isCorrectlySetup = false
	
	SignalGlobal.enemyHealthDepleted.connect(enemyHealthDepleted)
	SignalGlobal.enemyReachedExit.connect(enemyReachedExit.bind())
	
	if isCorrectlySetup:
		timer.wait_time = enemySpawnInterval
		timer.timeout.connect(_on_spawn_timer_timeout)
		
		var totalCount = 0
		for count in enemySpawnCount:
			totalCount += count
		enemySpawnCountTotal = totalCount
		enemiesAlive = enemySpawnCountTotal
		
		print_debug("enemySpawnCountTotal: %d, enemiesAlive: %d" % [enemySpawnCountTotal, enemiesAlive])

func setEnemyPath(enemyPath2D: Path2D):
	enemyPath = enemyPath2D

func start_wave():
	if !enemyPath:
		print_debug("enemy path not yet connected")
		return
		
	if !timer:
		print_debug("timer not connected correctly")
		return
	
	timer.start()

func _on_spawn_timer_timeout():
	if !isCorrectlySetup:
		print_debug("%s wave is not correctly setup. Turning off timer.")
		timer.stop()
	
	# If all enemies have already been spawned
	if (enemyTypeSpawnCounter >= enemySpawnList.size()):
		timer.stop()
		print("All enemies have already been spawned")
		return
		
	print_debug("enemyTypeSpawnCounter: %d, enemySpawnList.size(): %d" %
				[enemyTypeSpawnCounter, enemySpawnList.size()])
	
	# Spawn the enemy and start them
	var enemyPathFollower = enemyPathResource.instantiate()
	enemyPathFollower.linkEnemy(enemySpawnList[enemyTypeSpawnCounter])
	enemyPath.add_child(enemyPathFollower)
	enemyPathFollower.start()
	
	# Increment counters to be ready for next timeout
	print_debug("enemyTypeSpawnCounter: %d, enemySpawnList[%d]: %s, enemySpawnCount[%d]: %d, enemySpawnCounter: %d" %
				[enemyTypeSpawnCounter, enemyTypeSpawnCounter, enemySpawnList[enemyTypeSpawnCounter],
				 enemyTypeSpawnCounter, enemySpawnCount[enemyTypeSpawnCounter], enemySpawnCounter])
	enemySpawnCounter += 1
	if (enemySpawnCounter >= enemySpawnCount[enemyTypeSpawnCounter]):
		enemySpawnCounter = 0
		enemyTypeSpawnCounter += 1
		print_debug("Moving to next enemy type")

func enemyHealthDepleted():
	print_debug("enemy died")
	enemiesAlive -= 1
	print_debug("enemiesAlive: %d" % enemiesAlive)
	if (enemiesAlive == 0):
		waveOver.emit()
	
func enemyReachedExit(damage: int):
	print_debug("enemy dealt %d damage to the village" % damage)
	enemiesAlive -= 1
	print_debug("enemiesAlive: %d" % enemiesAlive)
	if (enemiesAlive == 0):
		waveOver.emit()
