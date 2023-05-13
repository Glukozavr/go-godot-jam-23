# A simple spawn component to spawn enemies on trigger with a timeout
extends Node3D

@export var enemy_scene: PackedScene
@export var spawn_node: Node3D
@export var debug := false

func _spawn():
	if debug:
		print_debug("Spawn Trigered: ", enemy_scene)
	# Create a new instance of the Enemy scene.
	var enemy = enemy_scene.instantiate()
	
	enemy.follow($Player, position)
	# Spawn the mob by adding it to the Main scene.
	spawn_node.add_child(enemy)
