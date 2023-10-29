extends CharacterBody2D
class_name Enemy

# Signals to pass to game manager
signal healthDepleted
signal exitReached(damage: int)

# Variables for enemy stats
@export var healthPoints: int = 1
@export var damage: int = 1
@export var moveSpeed: int = 100

# Variable used for helping tower decide which enemy to attack
var pathProgress: float = 0

# Variables for setting up the enemy node
var isCorrectlySetup: bool = true
var enemySprite: Sprite2D
var enemyCollision: CollisionShape2D
var healthComponent: HealthComponent
var hurtboxComponent: HurtboxComponent
var hurtboxCollision: CollisionShape2D
var attackComponent: AttackComponent
var hitboxComponent: HitboxComponent
var hitboxCollision: CollisionShape2D
var animations: AnimationPlayer

func _ready():
	enemySprite      = $Sprite2D
	enemyCollision   = $CollisionShape2D
	healthComponent  = $HealthComponent
	hurtboxComponent = $HurtboxComponent
	hurtboxCollision = $HurtboxComponent/CollisionShape2D
	attackComponent  = $AttackComponent
	hitboxComponent  = $HitboxComponent
	hitboxCollision  = $HitboxComponent/CollisionShape2D
	animations       = $AnimationPlayer

	# Check to see if all needed nodes for an enemy is added correctly
	if !enemySprite:
		isCorrectlySetup = false
		print_debug("%s enemySprite not correctly set up" % name)
	
	if !enemyCollision:
		isCorrectlySetup = false
		print_debug("%s enemyCollision not correctly set up" % name)
	
	if !healthComponent:
		isCorrectlySetup = false
		print_debug("%s healthComponent not correctly set up" % name)
	
	if !hurtboxComponent:
		isCorrectlySetup = false
		print_debug("%s hurtboxComponent not correctly set up" % name)
	
	if !hurtboxCollision:
		isCorrectlySetup = false
		print_debug("%s hurtboxCollision not correctly set up" % name)
		
	if !attackComponent:
		isCorrectlySetup = false
		print_debug("%s attackComponent not correctly set up" % name)
	
	if !hitboxComponent:
		isCorrectlySetup = false
		print_debug("%s hitboxComponent not correctly set up" % name)
	
	if !hitboxCollision:
		isCorrectlySetup = false
		print_debug("%s hitboxCollision not correctly set up" % name)
	
	if !animations:
		isCorrectlySetup = false
		print_debug("%s animations not correctly set up" % name)
		
	# Check if the collision shapes have a shape set up
	if enemyCollision && !enemyCollision.shape:
		isCorrectlySetup = false
		print_debug("%s enemyCollision shape not correctly set up" % name)
		
	if hitboxCollision && !hitboxCollision.shape:
		isCorrectlySetup = false
		print_debug("%s hitboxCollision shape not correctly set up" % name)
	
	if hurtboxCollision && !hurtboxCollision.shape:
		isCorrectlySetup = false
		print_debug("%s hurtboxCollision shape not correctly set up" % name)
		
	# Link the healthComponent/attackComponent with hurtboxComponent/hitboxComponent
	if !isCorrectlySetup:
		print_debug("Cannot set up component connections, %s enemy is not correctly set up" % name)
	else:
		hurtboxComponent.healthComponent = healthComponent
		hitboxComponent.attackComponent = attackComponent
		
	# Check if HealthComponent has been linked to HurtboxComponent
	if hurtboxComponent && !hurtboxComponent.healthComponent:
		isCorrectlySetup = false
		print_debug("%s hitboxComponent attackComponent link not correctly set up" % name)
	
	# Check if AttackComponent has been linked to HitboxComponent
	if hitboxComponent && !hitboxComponent.attackComponent:
		isCorrectlySetup = false
		print_debug("%s hitboxComponent attackComponent link not correctly set up" % name)
		
	# Setting up the event connections
	if !isCorrectlySetup:
		print_debug("Cannot set up signal connections, %s enemy is not correctly set up" % name)
	else:
		healthComponent.healthDepleted.connect(_on_health_component_health_depleted)
		hitboxComponent.area_entered.connect(_on_hitbox_component_area_entered.bind())
		
	# Set up the tower collision masks during runtime so we don't have to set it up when making tower in GUI
	if !isCorrectlySetup:
		print_debug("Cannot set up collision layers, %s enemy is not correctly set up" % name)
	else:
		collision_layer = 2
		collision_mask = 13
		hurtboxComponent.collision_layer = 2
		hurtboxComponent.collision_mask = 13
		hitboxComponent.collision_layer = 2
		hitboxComponent.collision_mask = 13

	# Used to make reading console output easier if there were problems with setup
	if !isCorrectlySetup:
		print_debug("---------------------------------------------------------------\n")
		
	# Set up enemy stats on ready during runtime
	setupStats()

# Used to help towers know which enemy in range is furthest or slowest in path
func setPathProgress(num: float):
	pathProgress = num

# Set up the health and attack components
func setupStats():
	if !isCorrectlySetup:
		print_debug("%s enemy is not correctly setup. Cannot set up stats." % name)
		return
		
	healthComponent.setHP(healthPoints)
	attackComponent.setDamage(damage)

# When enemy dies, emit a signal to let game manager know
func _on_health_component_health_depleted():
#	print_debug("%s health has been depleted." % name)
	healthDepleted.emit()
	queue_free()

# When enemy reaches exit, emit a signal to let game manager know
func _on_hitbox_component_area_entered(area):
#	print_debug("%s hitbox was entered by %s's %s" %
#				[get_parent().name, area.get_parent().name, area.name])
	# If enemy reaches the exit point of the stage
	if (area.name == "Exit"):
		exitReached.emit(attackComponent.damage)
		queue_free()
