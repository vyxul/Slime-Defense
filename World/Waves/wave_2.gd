extends Node2D

signal waveOver

@export var enemySpawnInterval: int = 1
@export var enemyList: Array = [
	"blue_slime",
	"blue slime",
	"BLUE SLIME",
	"blue_SLIME",
	"blue slime"
]
# keep enemy names as all lowercase and with "_" for delimeter
# protections in place to convert it to lowercase and change " " to "_"

@onready var timer = $SpawnTimer
@onready var enemySpawnTotal: int = enemyList.size()
@onready var enemiesAlive: int = enemySpawnTotal

var enemyPath: Path2D
var enemiesSpawned: int = 0
var enemyFollowerRsrc

# Called when the node enters the scene tree for the first time.
func _ready():
	print_debug("doing ready stuff for wave_1")
	# Set up the timer
	timer.wait_time = enemySpawnInterval
		
	SignalGlobal.enemyHealthDepleted.connect(enemyHealthDepleted)
	SignalGlobal.enemyReachedExit.connect(enemyReachedExit.bind())
	
	
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

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
	pass

func _on_spawn_timer_timeout():
	# If all enemies have already been spawned
	if (enemiesSpawned >= enemySpawnTotal):
		timer.stop()
		print("All enemies have already been spawned")
		return
		
	print_debug("enemiesSpawned: %d, enemySpawnTotal: %d" %
				[enemiesSpawned, enemySpawnTotal])
				
	var enemyName = enemyList[enemiesSpawned].replace(" ", "_").to_lower()
	enemyFollowerRsrc = load("res://Enemies/" + enemyName + "_follower.tscn")
	var enemyFollower = enemyFollowerRsrc.instantiate()
	enemyPath.add_child(enemyFollower)
	enemyFollower.start()
	enemiesSpawned += 1
	
	pass # Replace with function body.

func enemyHealthDepleted():
	print_debug("enemy died")
	enemiesAlive -= 1
	print_debug("enemiesAlive: %d" % enemiesAlive)
	if (enemiesAlive == 0 && (enemiesSpawned == enemySpawnTotal)):
		waveOver.emit()
	
func enemyReachedExit(damage: int):
	print_debug("enemy dealt %d damage to the village" % damage)
	enemiesAlive -= 1
	print_debug("enemiesAlive: %d" % enemiesAlive)
	if (enemiesAlive == 0 && (enemiesSpawned == enemySpawnTotal)):
		waveOver.emit()
