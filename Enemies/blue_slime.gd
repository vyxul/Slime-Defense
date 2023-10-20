extends CharacterBody2D



func _on_health_component_health_depleted():
	print_debug("%s health has been depleted." % name)
	queue_free()
	pass # Replace with function body.
