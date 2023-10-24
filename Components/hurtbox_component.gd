extends Area2D
class_name HurtboxComponent

@export var healthComponent: HealthComponent

func _ready():
#	if healthComponent:
#		print_debug(get_parent().name + " healthComponent found")
#	else:
#		print_debug(get_parent().name + " healthComponent not found")
	pass

func damage(attack: int):
	if (healthComponent):
		healthComponent.damage(attack)

# Dont actually need the hurtbox to detect hitbox
# I'm deciding to base the logic off of hitbox detecting hurtbox
#func _on_area_entered(area):
#	print_debug("%s hurtbox was entered by %s's %s" %
#				[get_parent().name, area.get_parent().name, area.name])
#	if (area is HitboxComponent):
#		print_debug("%s's %s area was detected as a HitboxComponent" %
#					[area.get_parent().name, area.name])
#	pass # Replace with function body.
