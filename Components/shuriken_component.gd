extends CharacterBody2D
class_name ShurikenComponent

@export var shurikenSpeed: int

@onready var animations = $"Shuriken Animation"


# Called when the node enters the scene tree for the first time.
func _ready():
#	throw(Vector2(2000, 2000))
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	move_and_slide()

func throw(throwPosition: Vector2):
	animations.play("spin")
	var shurikenDirection = position.direction_to(throwPosition)
#	print_debug("shurikenDirection: %s" % str(shurikenDirection))
	velocity = shurikenDirection * shurikenSpeed
#	print_debug("velocity: %s" % str(velocity))
	
func _on_visible_on_screen_notifier_2d_screen_exited():
#	print_debug("%s has left the screen, freeing from queue" % name)
	queue_free()


func _on_hitbox_component_area_entered(area):
	print_debug("%s hitbot was entered by %s's %s" %
				[get_parent().name, area.get_parent().name, area.name])
	if (area is HurtboxComponent):
		print_debug("%s's %s area was detected as a HurtboxComponent" % 
					[area.get_parent().name, area.name])
		queue_free()
	pass # Replace with function body.
