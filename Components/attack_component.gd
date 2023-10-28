extends Node2D
class_name AttackComponent

@export var damage: int


func setDamage(num: int):
	# do not allow damage <= 0
	if (num <= 0):
		print_debug("Given damage argument (%d) not allowed. Must be positive" % num)
		return
	
	damage = num
