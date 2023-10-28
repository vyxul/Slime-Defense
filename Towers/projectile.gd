extends CharacterBody2D
class_name Projectile

# Variables for setting up the projectile node
var isCorrectlySetup: bool = true
var sprite: Sprite2D
var hitboxComponent: HitboxComponent
var hitboxCollision: CollisionShape2D
var attackComponent: AttackComponent
var animations: AnimationPlayer
var onScreenNotifier: VisibleOnScreenNotifier2D
var movement: CollisionShape2D

# Variables for the specific projectile
var projectileSpeed: int = 0
var projectileDamage: int = 0
var projectilePierceLimit: int = 1
var enemiesPierced: int = 0

func _ready():
	sprite           = $Sprite2D
	hitboxComponent  = $Sprite2D/HitboxComponent
	hitboxCollision  = $Sprite2D/HitboxComponent/CollisionShape2D
	attackComponent  = $AttackComponent
	animations       = $AnimationPlayer
	onScreenNotifier = $VisibleOnScreenNotifier2D
	movement         = $CollisionShape2D

	# Check to see if all needed nodes for a projectile is added correctly
	if !sprite:
		isCorrectlySetup = false
		print_debug("%s sprite not correctly set up" % name)
	
	if !hitboxComponent:
		isCorrectlySetup = false
		print_debug("%s hitboxComponent not correctly set up" % name)
	
	if !hitboxCollision:
		isCorrectlySetup = false
		print_debug("%s hitboxCollision not correctly set up" % name)
	
	if !attackComponent:
		isCorrectlySetup = false
		print_debug("%s attackComponent not correctly set up" % name)
	
	if !animations:
		isCorrectlySetup = false
		print_debug("%s animations not correctly set up" % name)
	
	if !onScreenNotifier:
		isCorrectlySetup = false
		print_debug("%s onScreenNotifier not correctly set up" % name)
	
	if !movement:
		isCorrectlySetup = false
		print_debug("%s movement not correctly set up" % name)
		
	# Check if the collision shapes have a shape set up
	if hitboxCollision && !hitboxCollision.shape:
		isCorrectlySetup = false
		print_debug("%s hitboxCollision shape not correctly set up" % name)
		
	if movement && !movement.shape:
		isCorrectlySetup = false
		print_debug("%s movement shape not correctly set up" % name)
		
	# Check if AttackComponent has been linked to HitboxComponent
	if hitboxComponent && !hitboxComponent.attackComponent:
		isCorrectlySetup = false
		print_debug("%s hitboxComponent attackComponent link not correctly set up" % name)
		
	# Setting up the event connections
	if hitboxComponent:
		hitboxComponent.area_entered.connect(_on_hitbox_component_area_entered.bind())
	if onScreenNotifier:
		onScreenNotifier.screen_exited.connect(_on_visible_on_screen_notifier_2d_screen_exited)
	
	# Just for testing that projectile works
#	setSpeed(300)
#	move(Vector2(2000, 2000))

func _physics_process(delta):
	move_and_slide()

# Functions for setting the projectile stats during run time
func setSpeed(speed: int = 0):
	projectileSpeed = speed
func setDamage(damage: int = 0):
	projectileDamage = damage
	
	if isCorrectlySetup:
		attackComponent.damage = damage
	else:
		print_debug("Missing attack component, damage not fully set up")
func setPierceLimit(pierceLimit: int = 1):
	projectilePierceLimit = pierceLimit
func setCollisionLayer(num: int = 0):
	if !hitboxComponent:
		print_debug("%s hitboxComponent not correctly set up" % name)
	
	collision_layer = num
	hitboxComponent.collision_layer = num
func setCollisionMask(num: int = 0):
	if !hitboxComponent:
		print_debug("%s hitboxComponent not correctly set up" % name)
		
	# making projectile collision mask 0 to prevent projectile from straying off course for whatever reason
	collision_mask = 0
	hitboxComponent.collision_mask = num

# Need to change remove when off screen to when it hits the map bounds

# Removes the projectile when leaving the screen
func _on_visible_on_screen_notifier_2d_screen_exited():
	print_debug("%s has exited the screen, calling queue_free()" % name)
	queue_free()

# Removes the projectile when hitting a hurtbox
func _on_hitbox_component_area_entered(area):
	print_debug("%s's %s's %s hitbox was entered by %s's %s" %
				[get_parent().get_parent().name, get_parent().name, name, area.get_parent().name, area.name])
	if (area is HurtboxComponent):
		print_debug("%s's %s area was detected as a HurtboxComponent" % 
					[area.get_parent().name, area.name])
		enemiesPierced += 1
		
		if (enemiesPierced >= projectilePierceLimit):
			queue_free()

# Moves the projectile towards the given position
func move(targetPosition: Vector2):
	if !isCorrectlySetup:
		print_debug("%s is not correctly set up, returning from move()")
		return
	
	if animations.has_animation("moveAnimation"):
		animations.play("moveAnimation")
	else:
		print_debug("%s moveAnimation not found" % name)
	
	print_debug("%s moving from %s to %s" %
				[name, str(global_position), str(targetPosition)])
	var projectileDirection = position.direction_to(targetPosition)
#	print_debug("projectileDirection: %s" % str(projectileDirection))

	velocity = projectileDirection * projectileSpeed
#	print_debug("velocity: %s" % str(velocity))
