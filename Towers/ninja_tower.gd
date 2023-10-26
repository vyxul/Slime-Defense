extends Node2D

@export var attackCooldown: float = .5

@onready var shurikenComponent = preload("res://Components/shuriken_component.tscn")
@onready var attackTimer: Timer = $AttackTimer
@onready var top: Sprite2D = $TopSprite

var isAttacking: bool = false
var currentEnemy
var enemiesInRange: Array = []

# Called when the node enters the scene tree for the first time.
func _ready():
	print_debug("in ninja tower ready")
	attackTimer.wait_time = attackCooldown
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (enemiesInRange.is_empty()):
		return
		
	currentEnemy = enemiesInRange[0]
	top.look_at(currentEnemy.global_position)
	top.rotation += 90
	attack(currentEnemy.global_position)
	



func _on_tower_range_component_area_entered(area):
	print_debug("%s range was entered by %s's %s" %
				[get_parent().name, area.get_parent().name, area.name])
	enemiesInRange.append(area)
	
func _on_tower_range_component_area_exited(area):
	print_debug("%s range was exited by %s's %s" %
				[get_parent().name, area.get_parent().name, area.name])
	enemiesInRange.erase(area)

func attack(attackPosition: Vector2):
	print_debug("%s attacking at %s from %s" %
				[name, str(attackPosition), str(global_position)])
	if isAttacking:
		return
		
	isAttacking = true
	var shuriken = shurikenComponent.instantiate()
	owner.add_child(shuriken)
	shuriken.position = position
	shuriken.throw(attackPosition)
	attackTimer.start()

func _on_attack_timer_timeout():
	isAttacking = false


