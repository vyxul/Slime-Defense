extends Node2D

@export var attackCooldown: float = .5

@onready var shurikenComponent = preload("res://Components/shuriken_component.tscn")
@onready var projectileScene = preload("res://Components/Projectiles/fire_shuriken_projectile.tscn")
@onready var attackTimer: Timer = $AttackTimer
@onready var top: Sprite2D = $TopSprite
@onready var towerRangeShape: CollisionShape2D = $TowerRangeComponent/CollisionShape2D

var isAttacking: bool = false
var currentEnemy
var enemiesInRange: Array = []

# Called when the node enters the scene tree for the first time.
func _ready():
#	print_debug("in ninja tower ready")
	attackTimer.wait_time = attackCooldown
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if (enemiesInRange.is_empty()):
		return
		
	currentEnemy = enemiesInRange[0]
	topLookAt(currentEnemy.global_position)
#	top.rotation += 90
	if !isAttacking:
		attack(currentEnemy.global_position)
	

func topLookAt(enemyPosition: Vector2):
	var direction = top.global_position.direction_to(enemyPosition)
	var directionAngle = direction.angle()
	
	# If directionAngle is positive, can only look right, down, and left
	if (directionAngle > 0):
		# Look right
		if   (directionAngle <= (PI/4)):
			top.frame = 3
		# Look down
		elif (directionAngle >= (PI/4)) && (directionAngle <= (PI/4) * 3):
			top.frame = 0
		# Look left
		else:
			top.frame = 2
	# directionAngle is negative, can only look right, up, and left
	else:
		# Look right
		if   (directionAngle >= -(PI/4)):
			top.frame = 3
		# Look up
		elif (directionAngle <= -(PI/4)) && (directionAngle >= -(PI/4) * 3):
			top.frame = 1
		# Look left
		else:
			top.frame = 2

func _on_tower_range_component_area_entered(area):
	print_debug("%s range was entered by %s's %s" %
				[get_parent().name, area.get_parent().name, area.name])
	if area is HurtboxComponent:
		enemiesInRange.append(area)
	
func _on_tower_range_component_area_exited(area):
	print_debug("%s range was exited by %s's %s" %
				[get_parent().name, area.get_parent().name, area.name])
	
	if area is HurtboxComponent:
		enemiesInRange.erase(area)

func attack(attackPosition: Vector2):
	print_debug("%s attacking at %s from %s" %
				[name, str(attackPosition), str(global_position)])
	if isAttacking:
		print_debug("%s attack cooldown not finished yet" % name)
		return
		
	isAttacking = true
#	var shuriken = shurikenComponent.instantiate()
#	owner.add_child(shuriken)
#	shuriken.position = position
#	shuriken.throw(attackPosition)

	var projectile = projectileScene.instantiate()
	owner.add_child(projectile)
	projectile.position = position
	projectile.setSpeed(200)
	projectile.setDamage(1)
	projectile.setPierceLimit(3)
	projectile.setCollisionLayer(4)
	projectile.setCollisionMask(2)
	projectile.move(attackPosition)

	attackTimer.start()

func _on_attack_timer_timeout():
	isAttacking = false


