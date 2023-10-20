extends CharacterBody2D

@onready var healthComponent = $HealthComponent
@onready var hurtboxComponent = $HurtboxComponent
@onready var hitboxComponent = $HitboxComponent

var speed = 300.0
var runSpeed = speed * 2
var isRunning: bool = false
var direction: String = "Down"
var isAttacking: bool = false

func _ready():
	hitboxComponent.disable()

func handleInput():
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var moveDirection = Input.get_vector("left", "right", "up", "down")
	
	# Save the direction the player is moving in for animation purposes
	if   (moveDirection.y < 0): direction = "Up"
	elif (moveDirection.y > 0): direction = "Down"
	elif (moveDirection.x < 0): direction = "Left"
	elif (moveDirection.x > 0): direction = "Right"
	
	# Check if player should be running
	if (Input.is_action_pressed("shift")):
		velocity = moveDirection * runSpeed
		isRunning = true
	else:
		velocity = moveDirection * speed
		isRunning = false
		
	# Check if player is attacking
	if (Input.is_action_just_pressed("leftClick")):
		attack()
		
	# Just to easily debug
	if (Input.is_action_just_pressed("rightClick")):
		print_debug("----------------------")

# Just toggling attack on left click for now
func attack():
	if !isAttacking:
		isAttacking = true
		hitboxComponent.enable()
		
	else:
		isAttacking = false
		hitboxComponent.disable()

func _physics_process(delta):
	handleInput()
	move_and_slide()
