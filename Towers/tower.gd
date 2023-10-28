extends Node2D
class_name Tower

# Variables for setting up the tower node
var isCorrectlySetup: bool = true
var baseSprite: Sprite2D
var topSprite: Sprite2D
var towerCollision: StaticBody2D
var towerCollisionShape: CollisionShape2D
var towerRange: Area2D
var towerRangeShape: CollisionShape2D
var attackTimer: Timer

# Get the projectile(s) used
@export var projectileSceneString: String
var projectileScene: PackedScene

# Variables for tower mechanics
var isAttacking: bool = false
var currentEnemy = null
var enemiesInRange: Array = []

# Variables for tower/projectile stats
@export var attackCooldown: float = 1
@export var towerRangeMultiplier: float = 1
@export var projectileSpeed: int = 100
@export var projectileDamage: int = 1
@export var projectilePierce: int = 1

# Collision Layer/Mask shouldn't change unless they are changed in project settings
# 4 is for tower
# 2 is for enemy
var projectileCollisionLayer: int = 4
var projectileCollisionMask: int = 2

func _ready():
	# Get references to the different child nodes
	baseSprite          = $Sprite2D
	topSprite           = $Sprite2D2
	towerCollision      = $StaticBody2D
	towerCollisionShape = $StaticBody2D/CollisionShape2D
	towerRange          = $Area2D
	towerRangeShape     = $Area2D/CollisionShape2D
	attackTimer         = $Timer
	
	# Check to see if all needed nodes for a tower is added correctly
	if !baseSprite:
		isCorrectlySetup = false
		print_debug("%s baseSprite not correctly set up" % name)
		
	if !topSprite:
		isCorrectlySetup = false
		print_debug("%s topSprite not correctly set up" % name)
		
	if !towerCollision:
		isCorrectlySetup = false
		print_debug("%s towerCollision not correctly set up" % name)
		
	if !towerCollisionShape:
		isCorrectlySetup = false
		print_debug("%s towerCollisionShape not correctly set up" % name)
		
	if !towerRange:
		isCorrectlySetup = false
		print_debug("%s towerRange not correctly set up" % name)
		
	if !towerRangeShape:
		isCorrectlySetup = false
		print_debug("%s towerRangeShape not correctly set up" % name)
		
	if !attackTimer:
		isCorrectlySetup = false
		print_debug("%s attackTimer not correctly set up" % name)
		
	if !projectileSceneString:
		isCorrectlySetup = false
		print_debug("%s projectile scene not correctly set up" % name)
		
	# Check if the collision shapes have a shape set up
	if towerCollisionShape && !towerCollisionShape.shape:
		isCorrectlySetup = false
		print_debug("%s towerCollisionShape shape not correctly set up" % name)
	
	if towerRangeShape && !towerRangeShape.shape:
		isCorrectlySetup = false
		print_debug("%s towerRangeShape shape not correctly set up" % name)
		
	# Setting up the event connections
	if towerRange:
		towerRange.area_entered.connect(_on_area_2d_area_entered.bind())
		towerRange.area_exited.connect(_on_area_2d_area_exited.bind())
	if attackTimer:
		attackTimer.timeout.connect(_on_timer_timeout)
		
	# Get the projectile scene
	if projectileSceneString:
		if FileAccess.file_exists(projectileSceneString):
			projectileScene = load(projectileSceneString)
		else:
			print_debug("'%s' file path was not found" % projectileSceneString)
	# Check to make sure projectile scene loaded has needed methods
	if isCorrectlySetup && projectileScene.has_method("move"):
		isCorrectlySetup = false
		print_debug("%s projectile scene that was loaded did not have required method." % name)
		print_debug("projectileSceneString: %s" % projectileSceneString)
					
	# Set up the tower collision masks during runtime so we don't have to set it up when making tower in GUI
	if !isCorrectlySetup:
		print_debug("Cannot set up collision layers, %s tower is not correctly set up" % name)
	else:
		towerCollision.collision_layer = 4
		towerCollision.collision_mask = 15
		towerRange.collision_layer = 4
		towerRange.collision_mask = 2

	# Used to make reading console output easier if there were problems with setup
	if !isCorrectlySetup:
		print_debug("---------------------------------------------------------------\n")
		
	# Set the range multiplier when tower is made
	# If I go the path where tower upgrades are on same node as base tower, will need an event/signal
	# to update range
	towerRangeShape.scale *= towerRangeMultiplier

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !isCorrectlySetup:
		print_debug("%s tower is not correctly set up" % name)
		return
		
	if (enemiesInRange.is_empty()):
		return
		
	# Default is to get the enemy closest to the exit
	currentEnemy = enemiesInRange[0]
	topLookAt(currentEnemy.global_position)

	if !isAttacking:
		attack(currentEnemy.global_position)

# When enemy enters range of the tower, add them to list of enemies in range
func _on_area_2d_area_entered(area):
#	print_debug("%s range was entered by %s's %s" %
#				[name, area.get_parent().name, area.name])

	if area is HurtboxComponent:
		enemiesInRange.append(area)
		
# When enemy exits range of the tower, remove them from the list of enemies in range
func _on_area_2d_area_exited(area):
#	print_debug("%s range was exited by %s's %s" %
#				[name, area.get_parent().name, area.name])
	
	if area is HurtboxComponent:
		enemiesInRange.erase(area)

# On attackTimer timeout, let tower know that it is available to attack again
func _on_timer_timeout():
	isAttacking = false

# Controls which direction the topSprite looks at
func topLookAt(enemyPosition: Vector2):
	var direction = topSprite.global_position.direction_to(enemyPosition)
	var directionAngle = direction.angle()
	
	# directionAngle bounds are -PI <= angle <= PI with the right point as the origin
	# Look right
	if   (directionAngle >= -(PI/4)) && (directionAngle <= (PI/4)): 
		topSprite.frame = 3
	# Look down
	elif (directionAngle >= (PI/4)) && (directionAngle <= (PI/4) * 3): 
		topSprite.frame = 0
	# Look up
	elif (directionAngle <= -(PI/4)) && (directionAngle >= -(PI/4) * 3): 
		topSprite.frame = 1
	# Look left
	else: 
		topSprite.frame = 2

# Controls how the tower attacks the enemy
func attack(enemyPosition: Vector2):
	print_debug("%s attacking at %s from %s" %
				[name, str(enemyPosition), str(global_position)])
	if isAttacking:
		print_debug("%s attack cooldown not finished yet" % name)
		return
		
	isAttacking = true

	var projectile = projectileScene.instantiate()
	owner.add_child(projectile)
	projectile.position = position
	projectile.setSpeed(projectileSpeed)
	projectile.setDamage(projectileDamage)
	projectile.setPierceLimit(projectilePierce)
	projectile.setCollisionLayer(projectileCollisionLayer)
	projectile.setCollisionMask(projectileCollisionMask)
	projectile.move(enemyPosition)

	attackTimer.start(attackCooldown)
