extends CharacterBody2D

@export var shurikenMaxStacks: int
@export var shurikenCooldown: int

@onready var healthComponent = $HealthComponent
@onready var hurtboxComponent = $HurtboxComponent
@onready var weaponComponent = $WeaponComponent
@onready var abilityComponent = $AbilityComponent
@onready var moveAnimations = $"Movement Animation"

var speed = 300.0
var runSpeed = speed * 2
var isRunning: bool = false
var direction: String = "Down"
var isAttacking: bool = false
var isThrowing: bool = false
var attackOffset: int

func _ready():
	weaponComponent.disable()
	abilityComponent.abilitySetUp(shurikenMaxStacks, shurikenCooldown)

func handleInput():
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var moveDirection = Input.get_vector("left", "right", "up", "down")
	
	# Save the direction the player is moving in for animation purposes
	if   (moveDirection.y < 0): direction = "Up"
	elif (moveDirection.y > 0): direction = "Down"
	elif (moveDirection.x < 0): direction = "Left"
	elif (moveDirection.x > 0): direction = "Right"
	
	# if player moving
	if (moveDirection.length() > 0):
		# Check if player should be running
		if (Input.is_action_pressed("shift")):
			velocity = moveDirection * runSpeed
			isRunning = true
			if !isAttacking && !isThrowing:
				moveAnimations.play("sprint" + direction)
		else:
			velocity = moveDirection * speed
			isRunning = false
			if !isAttacking && !isThrowing:
				moveAnimations.play("move" + direction)
	# if player not moving
	else:
		velocity = Vector2(0, 0)
		isRunning = false
		moveAnimations.stop()
	
		
	# Check if player is attacking
	if (Input.is_action_pressed("leftClick")):
		isAttacking = true
		attack()
		
		# Figure out which way the player model should be facing
		var lookDirection = "Down"
		var mousePosition = get_local_mouse_position()
		if   (mousePosition.x < 0): lookDirection = "Left"
		elif (mousePosition.x > 0): lookDirection = "Right"
		elif (mousePosition.y < 0): lookDirection = "Up"
		elif (mousePosition.y > 0): lookDirection = "Down"
		moveAnimations.play("move" + lookDirection)
		
	else:
		isAttacking = false
		
	# Just to easily debug
	if (Input.is_action_just_pressed("q")):
		print_debug("----------------------")
		
	# If player using shuriken ability
	if (Input.is_action_just_pressed("rightClick")):
		shurikenAttack()
	
		isThrowing = true
		# Figure out which way the player model should be facing
		var lookDirection = "Down"
		var mousePosition = get_local_mouse_position()
		if   (mousePosition.x < 0): lookDirection = "Left"
		elif (mousePosition.x > 0):	lookDirection = "Right"
		elif (mousePosition.y < 0): lookDirection = "Up"
		elif (mousePosition.y > 0): lookDirection = "Down"
		moveAnimations.play("throw" + lookDirection)
	else:
		isThrowing = false

# Just toggling attack on left click for now
func attack():
	weaponComponent.attack()
	
func shurikenAttack():
	abilityComponent.useAbility(position)

func _physics_process(delta):
	handleInput()
	move_and_slide()
