extends CharacterBody2D
class_name BlueSlime

signal healthDepleted
signal exitReached(damage: int)

@export var moveSpeed: int = 100

@onready var animations = $"Movement Animation"
@onready var attackComponent = $AttackComponent

func _on_health_component_health_depleted():
	print_debug("%s health has been depleted." % name)
	healthDepleted.emit()
	queue_free()
	pass # Replace with function body.

func _ready():
	animations.play("moveDown")

func _on_hitbox_component_area_entered(area):
	print_debug("%s hitbox was entered by %s's %s" %
				[get_parent().name, area.get_parent().name, area.name])
	if (area.name == "Exit"):
		exitReached.emit(attackComponent.damage)
		queue_free()
		
	pass # Replace with function body.
