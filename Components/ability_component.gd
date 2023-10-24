extends Node2D
class_name AbilityComponent

@onready var shurikenComponent = preload("res://Components/shuriken_component.tscn")
@onready var shurikenGUI = preload("res://Player/shuriken_gui.tscn")
@onready var container = $HBoxContainer
@onready var timer = $Timer
@onready var label = $Control/VBoxContainer/Label2

var shurikenMaxStacks: int
var shurikenCurrentStacks: int
var shurikenCooldown: int
var shurikensGUI: Array

# Called when the node enters the scene tree for the first time.
func _ready():
#	shurikensGUI = container.get_children()
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
	
	for i in range(shurikenMaxStacks):
#		print_debug("i: %d, shurikenMaxStacks: %d" % [i, shurikenMaxStacks])
		var shuriken = shurikenGUI.instantiate()
		container.add_child(shuriken)
		
	shurikensGUI = container.get_children()
#	print_debug("shurikensGUI.size = %d" % shurikensGUI.size())
	
	
	label.text = str(shurikenCurrentStacks)
	timer.wait_time = cooldown
	timer.start()
	
	updateGUI()

func useAbility(position: Vector2):
	if (shurikenCurrentStacks <= 0):
		return
	
	var mousePosition = get_global_mouse_position()
#	print_debug("mousePosition: %s" % str(mousePosition))
	var shuriken = shurikenComponent.instantiate()
	shuriken.position = position
#	print_debug("shuriken.position: %s, position: %s" % [str(shuriken.position), str(position)])
	owner.owner.add_child(shuriken)
	shuriken.throw(mousePosition)
	shurikenCurrentStacks -= 1
	label.text = str(shurikenCurrentStacks)
	
	updateGUI()
	
	if (timer.is_stopped()):
		timer.start()

func _on_timer_timeout():
#	print_debug("shurikenCurrentStacks: %d, shurikenMaxStacks: %d" % [shurikenCurrentStacks, shurikenMaxStacks])
	if (shurikenCurrentStacks >= shurikenMaxStacks):
		timer.stop()
		return
		
	shurikenCurrentStacks += 1
	label.text = str(shurikenCurrentStacks)
	updateGUI()
	pass # Replace with function body.
