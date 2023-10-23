extends Node2D
class_name AbilityComponent

@onready var shurikenComponent = preload("res://Components/shuriken_component.tscn")
@onready var container = $HBoxContainer
@onready var timer = $Timer
@onready var label = $Control/VBoxContainer/Label2

var shurikenMaxStacks: int
var shurikenCurrentStacks: int
var shurikenCooldown: int
var shurikensGUI: Array

# Called when the node enters the scene tree for the first time.
func _ready():
	shurikensGUI = container.get_children()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func updateGUI():
	if (shurikenCurrentStacks <= 0):
		for shuriken in shurikensGUI:
			shuriken.update(1)
			
		return
	
	var index = 0
	while (index < shurikenCurrentStacks):
		shurikensGUI[index].update(0)
		index += 1
		
	while (index < shurikenMaxStacks):
		shurikensGUI[index].update(1)
		index += 1
	
	
func abilitySetUp(maxStacks: int, cooldown: int):
	shurikenMaxStacks = maxStacks
	shurikenCurrentStacks = 0
	shurikenCooldown = cooldown
	
	label.text = str(shurikenCurrentStacks)
	timer.wait_time = cooldown
	timer.start()
	
	updateGUI()

func useAbility(position):
	if (shurikenCurrentStacks <= 0):
		return
	
	var mousePosition = get_local_mouse_position()
	print_debug("mousePosition: %s" % str(mousePosition))
	var shuriken = shurikenComponent.instantiate()
	shuriken.position = position
	owner.add_child(shuriken)
	shuriken.throw(mousePosition)
	shurikenCurrentStacks -= 1
	label.text = str(shurikenCurrentStacks)
	
	updateGUI()
	
	if (timer.is_stopped()):
		timer.start()

func _on_timer_timeout():
	print_debug("shurikenCurrentStacks: %d, shurikenMaxStacks: %d" % [shurikenCurrentStacks, shurikenMaxStacks])
	if (shurikenCurrentStacks >= shurikenMaxStacks):
		timer.stop()
		return
		
	shurikenCurrentStacks += 1
	label.text = str(shurikenCurrentStacks)
	updateGUI()
	pass # Replace with function body.
