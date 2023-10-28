extends Area2D
class_name HitboxComponent

@export var attackComponent: AttackComponent

var hitboxCollision: CollisionShape2D

# Called when the node enters the scene tree for the first time.
func _ready():
	# Not currently used for anything, maybe can do aoe/single target stuff with it later
	hitboxCollision = get_child(0)
#	if !hitboxCollision:
#		print_debug(get_parent().name + " HitboxComponent child not found")
#	else:
#		print_debug(get_parent().name + " HitboxComponent child found")
#
#	if attackComponent:
#		print_debug(get_parent().name + " attackComponent found")
#	else:
#		print_debug(get_parent().name + "attackComponent not found")
		
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func enable():
	hitboxCollision.disabled = false
	visible = true
	
func disable():
	hitboxCollision.disabled = true
	visible = false

# I'm deciding to base logic off of hitbox detecting the hurtbox
# Could do it the other way around if wanted
func _on_area_entered(area):
#	print_debug("%s hitbox was entered by %s's %s" %
#				[get_parent().name, area.get_parent().name, area.name])
	if (area is HurtboxComponent):
#		print_debug("%s's %s area was detected as a HurtboxComponent" % 
#					[area.get_parent().name, area.name])
#		print_debug("%s passing damage (%s) to %s" % 
#					[get_parent().name, str(attackComponent.damage), area.get_parent().name])
		area.damage(attackComponent.damage)
	pass # Replace with function body.
