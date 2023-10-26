extends Node2D
class_name HealthComponent

signal healthDepleted
signal currentHpUpdated(num: int)
signal maxHpUpdated(num: int)

@export var maxHealthPoints: int
@export var healthPoints: int

# This variable isn't used yet but could be used for status effects later
# can also have flags for if under % of hp for berserk effect
var isMaxHp: bool = true

# Things to be done at start of entity life
func _ready():
	# Current HP should be at max at start of life
	# otherwise will lead to problems
	if (maxHealthPoints <= 0):
		print_debug(get_parent().name + " max hp (%d) not set up correctly" % maxHealthPoints)
		
	healthPoints = maxHealthPoints

# Called just to update the max hp of the entity
# if current hp is less than new max hp, adjust that to max hp also
func updateMaxHealth(num: int):
	# do not allow max hp <= 0
	if (num <= 0):
		print_debug("Given max hp argument (%d) not allowed. Must be positive")
		return
		
	maxHealthPoints = num
	print_debug(get_parent().name + " max hp updated to %d" % maxHealthPoints)
	maxHpUpdated.emit(maxHealthPoints)
	if (maxHealthPoints < healthPoints):
		updateCurrentHealth(maxHealthPoints)

# Called just to update the current hp of the entity
func updateCurrentHealth(num: int):
	# If the new hp <= 0, just emit signal that unit is dead and skip the rest
	if (num <= 0):
#		print_debug(get_parent().name + " new hp (%d) <= 0" % num)
		healthPoints = 0
		healthDepleted.emit()
		return
		
	# If the new hp > maxHp, just set current hp to max hp and skip the rest
	# can shorten code by making hp = min(num, maxHp) but this is easier to understand for me
	if (num > maxHealthPoints):
		print_debug(get_parent().name + " new hp (%d) higher than max (%d)" % [num, maxHealthPoints])
		healthPoints = maxHealthPoints
		isMaxHp = true
		return
		
	# isMaxHp not used yet but could be used for buffs later, just setting it up for now
	# set up the true part in the code block above
	if (num < maxHealthPoints):
		isMaxHp = false
		
	healthPoints = num
#	print_debug(get_parent().name + " new hp: %d" % healthPoints)
	currentHpUpdated.emit(healthPoints)

# Called just to calculate the new hp of the entity by current hp - given damage argument
func damage(num: int):
	if (num <= 0):
		print_debug(get_parent().name + " was damaged with zero or negative number (%d)" % num)
		return
	
#	print_debug(get_parent().name + " was hurt by %d damage" % num)
	updateCurrentHealth(healthPoints - num)
	
# Called just to calculate the new hp of the entity by current hp + given heal argument
# Can use damage with a negative num argument but this is easier to understand
func heal(num: int):
	if (num <= 0):
		print_debug(get_parent().name + " was healed with zero or negative number (%d)" % num)
		return
	
#	print_debug(get_parent().name + " was healed by %d hp" % num)
	updateCurrentHealth(healthPoints + num)

func _to_string():
	return get_parent().name + " HP Component = [Max HP: " + str(maxHealthPoints) + ", Current HP: " + str(healthPoints) + "]"
