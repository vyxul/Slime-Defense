extends Node2D
class_name WeaponComponent

@export var hitboxComponent: HitboxComponent
@export var attackComponent: AttackComponent

@onready var animations: AnimationPlayer = $"Weapon Animation"
@onready var sprite: Sprite2D = $"Weapon Sprite"

var hitboxCollision: CollisionShape2D
var isAttacking: bool = false
var weaponOffset: int

# Called when the node enters the scene tree for the first time.
func _ready():
	hitboxComponent = $"Weapon Sprite/HitboxComponent"
	hitboxCollision = hitboxComponent.get_node("Hitbox Collision")
	attackComponent = $AttackComponent
	
	weaponOffset = hitboxCollision.position.length()
	sprite.visible = false
	pass # Replace with function body.

func attack():
#	if !isAttacking:
	isAttacking = true
	hitboxComponent.enable()
	var mousePosition = get_viewport().get_mouse_position()
#		var attackDirection = (mousePosition - position).normalized()
	var attackDirection = get_parent().position.direction_to(mousePosition)
	var attackPosition = attackDirection * Vector2(weaponOffset, weaponOffset)
	sprite.position = attackPosition
	sprite.look_at(mousePosition + sprite.position)
	
	animations.play("slashCurved")
	await animations.animation_finished
	isAttacking = false
		
#	else:
#		isAttacking = false
#		hitboxComponent.disable()
		
func disable():
	hitboxComponent.disable()
