extends Control

@export var enemySpawnTime: int
@export var enemySpawnMax: int
@export var villageHealth: int = 10

@onready var player = $Player
@onready var camera = $Player/Camera2D
@onready var map = $TileMap
@onready var timer = $SpawnTimer
@onready var path = $EnemyPath
@onready var blueSlimeFollower = preload("res://Enemies/blue_slime_follower.tscn")
@onready var tower = load("res://Towers/ninja_base_tower.tscn")
@onready var towerPlacementBox = $TowerPlacementBox

var enemySpawnCount: int = 0
var currentWave: int = 0
var wave

var inPlacementMode: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
#	print_debug("in ready of ninja village")
	
	# Set up camera bounds variables
	var mapSize = map.get_used_rect()
	var tileSize = map.cell_quadrant_size
	
	# Get the bounds in pixels
	var limit_left  = 0
	var limit_right  = mapSize.size.x * tileSize
	var limit_top    = 0
	var limit_bottom = mapSize.size.y * tileSize
	
	# Set the camera bounds
	camera.limit_left = limit_left
	camera.limit_right = limit_right
	camera.limit_top = limit_top
	camera.limit_bottom = limit_bottom
	
#	timer.wait_time = enemySpawnTime
#	timer.start()
	
	# Setting up global signals
	SignalGlobal.enemyHealthDepleted.connect(enemyHealthDepleted)
	SignalGlobal.enemyReachedExit.connect(enemyReachedExit.bind())
	
#	var waveResource = load("res://World/Waves/wave_" + str(currentWave) + ".tscn")
#	wave = waveResource.instantiate()
#	add_child(wave)
#	wave.setEnemyPath(path)
#	wave.start_wave()
#	wave.waveOver.connect(waveOver)

#	var waveResource = load("res://World/Waves/wave_" + str(currentWave) + ".tscn")
#	wave = waveResource.instantiate()
#	add_child(wave)
#	wave.setEnemyPath(path)
#	wave.start_wave()
#	wave.waveOver.connect(waveOver)
	nextWave()
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _input(event):
	# For toggling the towerPlacementBox
	if event.is_action_pressed("b"):
		print_debug("b button toggled")
		
		inPlacementMode = !inPlacementMode
		$TowerPlacementBox.setPlacementMode(inPlacementMode)
		
	if inPlacementMode and towerPlacementBox.getPlacementOkay() and event.is_action_pressed("leftClick"):
		var towerNode = tower.instantiate()
		towerNode.position = get_global_mouse_position()
		add_child(towerNode)
		
	if event.is_action_pressed("scroll_down"):
		var currentZoom: Vector2 = camera.get_zoom()
		if currentZoom <= Vector2(.5, .5):
			return
			
		var newZoom: Vector2 = currentZoom - Vector2(.1, .1)
		camera.set_zoom(newZoom)
		
	if event.is_action_pressed("scroll_up"):
		var currentZoom: Vector2 = camera.get_zoom()
		if currentZoom >= Vector2(2, 2):
			return
			
		var newZoom: Vector2 = currentZoom + Vector2(.1, .1)
		camera.set_zoom(newZoom)

func enemyHealthDepleted():
#	print_debug("enemy died")
#	enemySpawnCount -= 1
	
#	if timer.is_stopped():
#		timer.start()
	pass
	
func enemyReachedExit(damage: int):
#	print_debug("enemy dealt %d damage to the village" % damage)
#	enemySpawnCount -= 1
#
#	if timer.is_stopped():
#		timer.start()
	pass

func waveOver():
	print_debug("Wave %d over" % currentWave)
	wave.queue_free()
	nextWave()
	
func nextWave():
	currentWave += 1
	print_debug("Starting Wave %d" % currentWave)
	
	var fileExists = FileAccess.file_exists("res://World/Waves/wave_" + str(currentWave) + ".tscn")
	if !fileExists:
		print_debug("Scene for wave %d not found" % currentWave)
		return
	
	var waveResource = load("res://World/Waves/wave_" + str(currentWave) + ".tscn")
	wave = waveResource.instantiate()
	add_child(wave)
	wave.setEnemyPath(path)
	wave.start_wave()
	wave.waveOver.connect(waveOver)
	

func _on_spawn_timer_timeout():
	if (enemySpawnCount < enemySpawnMax):
		enemySpawnCount += 1
		var slime = blueSlimeFollower.instantiate()
		slime.exitReached.connect(enemyReachedExit.bind())
		slime.healthDepleted.connect(enemyHealthDepleted)
		path.add_child(slime)
		print_debug("enemySpawnCount: %d, enemySpawnMax: %d, spawning slime" % 
					[enemySpawnCount, enemySpawnMax])
					
	else:
		print_debug("enemySpawnCount: %d, enemySpawnMax: %d, not spawning slime" % 
					[enemySpawnCount, enemySpawnMax])
		timer.stop()


func _on_map_bounds_area_entered(area):
#	print_debug("%s's MapBounds entered by %s" % [name, area.name])
	pass # Replace with function body.
