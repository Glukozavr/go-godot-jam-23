# A simple spawn component to spawn enemies on trigger with a timeout
extends Node3D
class_name Spawn

@export var enemy_scene: PackedScene
@export var debug := false

func spawn(player, spawn_node):
	if debug:
		print_debug("Spawn Trigered: ", enemy_scene)
	# Create a new instance of the Enemy scene.
	var enemy = enemy_scene.instantiate()
	
	spawn_node.add_child(enemy)
	
	enemy.follow(player, global_position)
	# Spawn the mob by adding it to the Main scene.
